class MediaRocket::Site
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String
  
  has n, :categories
  has n, :medias
  
end
