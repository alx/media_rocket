class MediaRocket::AssociatedFile
  include DataMapper::Resource
 
  property :media_id, Integer, :key => true
  property :file_id, Integer, :key => true
 
  belongs_to :media, :class_name => "MediaRocket::MediaFile", :child_key => [:media_id]
  belongs_to :file, :class_name => "MediaRocket::MediaFile", :child_key => [:file_id]
end