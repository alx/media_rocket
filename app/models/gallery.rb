class MediaRocket::Gallery
  include DataMapper::Resource
  
  property :id, Serial
  property :parent_id, Integer
  property :name, String
  
  is_tree :order => "id"
  
  belongs_to :site, :class_name => "MediaRocket::Site"
  has n, :medias, :class_name => "MediaRocket::MediaFile"
  
  before :destroy, :clean_category

  def add_child(name)
    children.first_or_create :name => name, 
                             :parent_id => id,
                             :site_id => site.id
  end
  
  def clean_category
    children.each{ |category| category.destroy }
    medias.each{ |media| media.destroy }
    self.site.reload
  end
end
