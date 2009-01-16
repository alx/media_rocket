class MediaRocket::Gallery
  include DataMapper::Resource
  
  property :id, Serial
  property :parent_id, Integer
  property :name, String
  
  is_tree :order => "name"
  
  belongs_to :site, :class_name => "MediaRocket::Site"
  has n, :medias, :class_name => "MediaRocket::MediaFile"

  def add_child(name)
    children.first_or_create :name => name, 
                             :parent_id => id,
                             :site_id => site.id
  end
end
