class MediaRocket::Site
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String
  property :domain, String
  
  has n, :galleries, :class_name => ::MediaRocket::Gallery
  has n, :medias, :class_name => ::MediaRocket::MediaFile

end