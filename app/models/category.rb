class MediaRocket::Category
  include DataMapper::Resource
  
  property :id, Serial
  property :parent_id, Integer
  property :name, String
  
  is_tree :order => "name"
  
  belongs_to :site
  has n, :medias
  
end
