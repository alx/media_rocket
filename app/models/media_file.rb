class MediaRocket::MediaFile
  include DataMapper::Resource
  
  property :id, Serial
  property :path, FilePath, :nullable => false
  property :md5sum, String, :length => 32, :default => Proc.new { |r, p| Digest::MD5.hexdigest(r.path.read) if r.path }
  property :title, String
  property :description, Text, :default => ""
  property :position, Integer
  property :stage, Integer
  property :created_at, DateTime
  
  property :dimension_max, String
  property :dimension_x, Integer
  property :dimension_y, Integer
  
  has_tags
  
  default_scope(:default).update(:order => [:position])
  
  #
  # Media can have associated files, with has and belongs to many association
  #
  # It'll help when user will send various format of the same information,
  # or when they'll need a file to be presented and another file to be downloaded
  #
  # For exemple, if we know the id of the file is "calabacina",
  # and that one is associated with it, we can do:
  #
  # /calabacina <- to get the original file
  # /calabacina/associated/1 <- to get the first associated file
  # /calabacina/associated/eps <- to get the list of associated files with "eps" tag,
  # if there's only 1 file associated with this tag, it will return the file
  # 
  has n, :associated_files, :class_name => ::MediaRocket::AssociatedFile
  has n, :files, :through => :associated_files, :class_name => ::MediaRocket::MediaFile,
                   :remote_name => :file, :child_key => [:media_id]
  has n, :associated_to, :through => :associated_files, :class_name => ::MediaRocket::MediaFile,
                       :remote_name => :media, :child_key => [:file_id]
  
  belongs_to :gallery,  :class_name => ::MediaRocket::Gallery,  :child_key => [:gallery_id]
  belongs_to :site,     :class_name => ::MediaRocket::Site,     :child_key => [:site_id]
  
  after :save, :post_process
  before :destroy, :unlink_files
  
  #
  # Initialize media
  #
  # parameters:
  #   - options[:file] => tmp file to the uploaded file
  #   - options[:tags] => tag list to be applied to this media, separated by options[:delimiter]
  #   - options[:delimiter] => delimiter to be used to split the tag list
  #
  # return:
  #   - nil if options[:file] was not specified
  #   - new media
  #
  def initialize(options = {}, &block)
    
    if options[:file]
      
      self.title = (options[:title] || options[:file][:filename])
      self.description = options[:description] if options[:description]

      # Find or create if options[:site] is specified
      # And link this @site to the current object
      if (options[:site_id] || options[:site_name])
        add_to_site options
      end
      
      # Add unique suffix if file already exists
      # FIX: rework using unique sha1 hash for basename
      Merb.logger.info "options filename: #{options[:file][:filename]}"
      self.path = unique_file(root_path, options[:file][:filename])

      # Create directory if doesn't exist (when new site or gallery)
      # and move file there
      FileUtils.mkdir_p File.dirname(self.path) unless File.directory?(File.dirname(self.path))
      FileUtils.mv options[:file][:tempfile].path, self.path
      
    else
      
      # options[:file] is mandatory,
      # it'll return nil if absent
      return nil
      
    end
    
    add_tags(options) unless options[:tags].nil?
    
    # If options[:stage] == 1, file has been processed
    self.stage = options[:stage] if options[:stage]
    
    if is_image?
      self.dimension_max = options[:dimension] if options[:dimension]
      self.dimension_x, self.dimension_y = image_dimension(self.path)
    end
  end
  
  def add_tags(options = {}, &block)
    delimiter = options[:delimiter] || '+'
    self.tag_list = options[:tags].split(delimiter).inspect{|tag| tag.strip}
  end
  
  #
  # Build url that will be understand by router to downlad/display this file
  #
  def url
    return "/" + Pathname.new(self.path).relative_path_from(Pathname.new(File.join(Merb.root, 'public'))).to_s
  end
  
  #
  # Return true if current media is an image (jpg, png or gif)
  #
  def is_image?
    (self.mime =~ /(jpg|gif|png)/) != nil
  end
  
  #
  # Return thumbnail media associated to this file
  #
  def thumbnail
    (self.files.select{|media| media.dimension_max == "130x130"}.first || nil) if is_image?
  end
  
  def icon
    if is_image? && original?
      file = self.files.select{|media| media.dimension_max == "130x130"}.first
      file.nil? ? ::MediaRocket.public_path_for(:image, "media_icon.png") : file.url
    else
      ::MediaRocket.public_path_for :image, "icons/mimetypes/#{self.mime}.png"
    end
  end
  
  def mime
    File.extname( self.path ).gsub( /^\./, '' ).downcase
  end
  
  def original?
    self.associated_to.size == 0
  end
  
  def to_json
    "{\"id\": #{self.id}, \"name\": \"#{self.title}\", \"icon\": \"#{self.icon}\"" << 
    "\"url\": \"#{self.url}\", \"mime\": \"#{self.mime}\"}"
  end
  
  private
  
  #
  # Create hierarchy with options[:site]
  # and options[:gallery]
  #
  def add_to_site(options = {}, &block)
    
    if !options[:site_name].nil? && !options[:site_name].empty?
      self.site = ::MediaRocket::Site.first_or_create(:name => options[:site_name])
    elsif !options[:site_id].nil? && !options[:site_id].to_s.empty?
      self.site = ::MediaRocket::Site.first(:id => options[:site_id])
    end  
    
    return false if self.site.nil?
    
    self.site.medias << self
    self.site.reload
    
    if options[:gallery_id] || options[:gallery_name]
      
      if !options[:gallery_name].nil? && !options[:gallery_name].empty?
        self.gallery = ::MediaRocket::Gallery.first_or_create(:name => options[:gallery_name], :site_id => self.site.id)        
      elsif !options[:gallery_id].nil? && !options[:gallery_id].to_s.empty?
        self.gallery = ::MediaRocket::Gallery.first(:id => options[:gallery_id], :site_id => self.site.id)
      end
      
      return false if self.gallery.nil?
      
      self.gallery.medias << self
      self.gallery.reload
      self.position = options[:position] || self.gallery.medias.size
      
    end
  end
  
  #
  # Create an unique filename
  # to be place in the path parameter
  #
  def unique_file(path, filename)
    Merb.logger.debug "path: #{path}"
    Merb.logger.debug "filename: #{filename}"
    path = File.join(path, Digest::MD5.hexdigest(filename))
    return (path << File.extname(filename))
  end
  
  #
  # Path to the directory where the file should be saved
  #
  def root_path
    path = "/public/uploads/"
    path = File.join(path, self.site.name) if self.site
    path = File.join(path, Time.now.strftime("%Y/%I/%d"))
    return File.join(Merb.root, path)
  end
  
  #
  # Method to run after saving a media for unprocessed media
  # It reacts differently depending on the kind of media:
  #
  #    - image: create resized pictures
  #    - video: ???
  #    - pdf: ???
  #
  def post_process
    if !is_processed?
      image_process if is_image?
      self.update_attributes(:stage => 1)
      
      # Reload site and gallery to take care of new comers
      self.site.reload if self.site
      self.gallery.reload if self.gallery
    end
  end
  
  #
  # Process image to resize it
  #
  def image_process
    # Add _t suffix to filename for thumbnail filename
    @thumbnail = convert_image("130x130")
    @thumbnail.save
    ::MediaRocket::AssociatedFile.create(:media => self, :file => @thumbnail)
    
    # Add _m suffix to filename for medium filename
    @medium = convert_image("850x550")
    @medium.save
    ::MediaRocket::AssociatedFile.create(:media => self, :file => @medium)
  end
  
  def image_dimension(filename)
    image = Magick::Image.read(filename)[0]
    return image.columns, image.rows
  end
  
  #
  # Method to convert current image to filename
  # using size dimensions 
  #
  def convert_image(size)
    convert_file = Tempfile.new("convert")
    
    # Run convert to generate thumbnail
    convert_command = "convert -size #{size} #{self.path} \
                       -strip -coalesce -resize #{size} \
                       -quality 100 #{convert_file.path}"
    `#{convert_command}`
    
    media_hash = { :file => { :filename => (size + File.basename(self.path)),
                              :tempfile => convert_file },
                   :stage => 1,
                   :dimension => size}
    
    media_hash.merge!({:site_id => self.site.id}) if self.site
    media_hash.merge!({:gallery_id => self.gallery.id}) if self.gallery
                   
    ::MediaRocket::MediaFile.new(media_hash)
  end
  
  #
  # Allows to know if file has already been processed
  # Permits to forbid infinite loop on post_process
  #
  def is_processed?
    (self.stage == 1)
  end
  
  def unlink_files
    self.files.each{ |media| media.destroy }
    File.delete(self.path) if File.exists?(self.path)
    
    # Reload site and gallery to be sure everything is gone
    self.site.reload
    self.gallery.reload
  end
end