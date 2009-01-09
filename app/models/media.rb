class MediaRocket::Media
  include DataMapper::Resource
  
  property :id, Serial
  property :path, FilePath, :nullable => false
  property :md5sum, String, :length => 32,
                   :default => Proc.new { |r, p| Digest::MD5.hexdigest(r.path.read) if r.path }
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
      
      @path = File.join(MediaRocket.root, "/public/uploads/", File.basename(options[:file]))
      
      unique = 0 if File.exist?(@path)
      while File.exist?(@path)
        @path = File.join(MediaRocket.root, "/public/uploads/", File.basename(options[:file]) + unique.to_s)
        unique += 1
      end
      
      if options[:site]
        @site = MediaRocket::Site.first(:name => options[:site])
        @site = MediaRocket::Site.new(:name => options[:site]).save if @site.nil?
      end
      
      FileUtils.mv options[:file], @path
    else
      return nil
    end
    
    add_tags(options) unless options[:tags].nil?
  end
  
  def add_tags(options = {}, &block)
    delimiter = options[:delimiter] || '+'
    @tag_list = options[:tags].split(delimiter)
  end
  
  #
  # Build url that will be understand by router to downlad/display this file
  #
  def url
    path = "/uploads/"
    path << @site.name << "/" if @site
    path << File.basename(@path)
    path
  end
  
  private
  
  def post_process
  end
end
