class MediaRocket::Media
  include DataMapper::Resource
  
  property :id, Serial
  property :path, FilePath, :nullable => false
  property :md5sum, String, :length => 32, :default => Proc.new { |r, p| Digest::MD5.hexdigest(r.path.read) if r.path }
  property :title, String
  property :description, String
  property :position, Integer
  property :stage, Integer
  property :dimension, String
  property :created_at, DateTime
  property :deleted_at, ParanoidDateTime
  property :deleted,    ParanoidBoolean
  
  has_tags
  
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
  has n, :associated_files, :class_name => "MediaRocket::AssociatedFile"
  has n, :files, :through => :associated_files, :class_name => "MediaRocket::Media",
                   :remote_name => :file, :child_key => [:media_id]
  has n, :associated_to, :through => :associated_files, :class_name => "MediaRocket::Media",
                       :remote_name => :media, :child_key => [:file_id]
  
  belongs_to :category, :class_name => "MediaRocket::Category"
  belongs_to :site, :class_name => "MediaRocket::Site"
  
  after :save, :post_process
  
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
      
      # Add unique suffix if file already exists
      # FIX: rework using unique sha1 hash for basename
      self.path = unique_file(root_path, options[:file][:filename])

      # Create directory if doesn't exist (when new site or category)
      # and move file there
      FileUtils.mkdir_p File.dirname(self.path) unless File.directory?(File.dirname(self.path))
      FileUtils.mv options[:file][:tempfile].path, self.path
      
    else
      
      # options[:file] is mandatory,
      # it'll return nil if absent
      return nil
      
    end
    
    self.title = options[:title] if options[:title]
    self.description = options[:description] if options[:description]
    
    # Find or create if options[:site] is specified
    # And link this @site to the current object
    if options[:site]
      add_to_site options
    end
    
    add_tags(options) unless options[:tags].nil?
    
    # If options[:stage] == 1, file has been processed
    self.stage = options[:stage] if options[:stage]
    self.dimension = options[:dimension] if options[:dimension]
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
    (self.path =~ /(jpg|gif|png)$/) != nil
  end
  
  private
  
  #
  # Create hierarchy with options[:site]
  # and options[:category]
  #
  def add_to_site(options = {}, &block)
    self.site = MediaRocket::Site.first_or_create(:name => options[:site])
    self.site.medias << self
    
    # Find or create if options[:site] is specified
    # And link this @site to the current object
    if options[:category]
      self.category = MediaRocket::Category.first_or_create(:name => options[:category])
      self.category.medias << self
      self.site.categories << self.category
      
      # Add position number with medias category size if not existing in options
      self.position = options[:position] || self.category.medias.size
    end
  end
  
  #
  # Create an unique filename
  # to be place in the path parameter
  #
  def unique_file(path, filename)
    unique = 0
    path = File.join(path, filename)
    extension = File.extname(filename)
    
    while File.exist?(path)
      path = File.join(File.dirname(path), File.basename(filename, extension) + unique.to_s + extension)
      unique += 1
    end
    return path
  end
  
  #
  # Path to the directory where the file should be saved
  #
  def root_path
    path = "/public/uploads/"
    path = File.join(path, self.site.name) if self.site
    path = File.join(path, self.category.name) if self.category
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
    end
  end
  
  #
  # Process image to resize it
  #
  def image_process
    
    image_file = File.basename(self.path)
    
    # Add _t suffix to filename for thumbnail filename
    @thumbnail = convert_image(image_file.gsub(/(\..{3})$/, '_t\1'), "130x130")
    @thumbnail.save
    MediaRocket::AssociatedFile.create(:media => self, :file => @thumbnail)
    
    # Add _m suffix to filename for medium filename
    @medium = convert_image(image_file.gsub(/(\..{3})$/, '_m\1'), "850x550")
    @medium.save
    MediaRocket::AssociatedFile.create(:media => self, :file => @medium)
  end
  
  #
  # Method to convert current image to filename
  # using size dimensions 
  #
  def convert_image(filename, size)
    convert_file = Tempfile.new("convert")
    
    # Run convert to generate thumbnail
    `convert -size #{size} #{self.path} \
            -strip -coalesce -resize #{size} \
            -quality 100 #{convert_file.path}`
    
    media_hash = { :file => { :filename => filename,
                              :tempfile => convert_file },
                   :stage => 1,
                   :dimension => size}
                   
    MediaRocket::Media.new(media_hash)
  end
  
  #
  # Allows to know if file has already been processed
  # Permits to forbid infinite loop on post_process
  #
  def is_processed?
    (self.stage == 1)
  end
end
