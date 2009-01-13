class MediaRocket::Media
  include DataMapper::Resource
  
  property :id, Serial
  property :path, FilePath, :nullable => false
  property :md5sum, String, :length => 32, :default => Proc.new { |r, p| Digest::MD5.hexdigest(r.path.read) if r.path }
  property :title, String
  property :description, String
  property :position, Integer
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
  has n, :associated_files
  has n, :files, :through => :associated_files, :class_name => "MediaRocket::Media",
                   :child_key => [:file_id]
  has n, :associated_to, :through => :associated_files, :class_name => "MediaRocket::Media",
                       :remote_name => :media, :child_key => [:file_id]
  
  belongs_to :category, :class_name => "MediaRocket::Category"
  belongs_to :site, :class_name => "MediaRocket::Site"
  
  after :save, :post_process
  
  #
  # Initialize media
  #
  # parameters:
  #   - options[:upload_file] => tmp file to the uploaded file
  #   - options[:tags] => tag list to be applied to this media, separated by options[:delimiter]
  #   - options[:delimiter] => delimiter to be used to split the tag list
  #
  # return:
  #   - nil if options[:upload_file] was not specified
  #   - new media
  def initialize(options = {}, &block)
    if options[:file]
      
      self.title = options[:title] if options[:title]
      self.description = options[:description] if options[:description]
      
      # Find or create if options[:site] is specified
      # And link this @site to the current object
      if options[:site]
        add_to_site options
      end
      
      # Add unique suffix if file already exists
      # FIX: rework using unique sha1 hash for basename
      self.path = unique_file(File.join(Merb.root, root_path), options[:file][:filename])

      # Create directory if doesn't exist (when new site or category)
      # and move file there
      FileUtils.mkdir_p File.dirname(self.path) unless File.directory?(File.dirname(self.path))
      FileUtils.mv options[:file][:tempfile].path, self.path
    else
      return nil
    end
    
    add_tags(options) unless options[:tags].nil?
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
  
  private
  
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
  
  def root_path
    path = "/public/uploads/"
    path = File.join(path, self.site.name) if self.site
    path = File.join(path, self.category.name) if self.category
    return path
  end
  
  def post_process
  end
end
