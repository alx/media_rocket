class MediaRocket::Category
  include DataMapper::Resource
  
  property :id, Serial
  property :parent_id, Integer
  property :name, String
  
  is_tree :order => "name"
  
  belongs_to :site
  has n, :medias
  
  def initialize(options = {}, &block)
    if options[:site]
      @site = MediaRocket::Site.first_or_create(:name => options[:site])
      @site.category << self
    end
  end
end
