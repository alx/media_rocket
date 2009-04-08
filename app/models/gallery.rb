class MediaRocket::Gallery
  include DataMapper::Resource
  
  property :id, Serial
  property :parent_id, Integer
  property :name, String
  property :description, Text
  property :ref_title, Text
  property :ref_meta, Text
  
  has_tags
  
  is_tree :order => "id"
  
  belongs_to :site, :class_name => ::MediaRocket::Site, :child_key => [:site_id]
  
  has n, :medias,       :class_name => ::MediaRocket::MediaFile
  has n, :permissions,  :class_name => ::MediaRocket::GalleryPermission
  
  before  :destroy, :clean_gallery

  def add_child(name)
    children.first_or_create :name => name, 
                             :parent_id => id,
                             :site_id => site.id
  end
  
  def clean_gallery
    children.each{ |gallery| gallery.destroy }
    medias.each{ |media| media.destroy }
    self.site.reload
  end
  
  def url
    "/gallery/" + id.to_s + "-" + url_escape(name)
  end
  
  def url_escape(string)
    string.gsub(/([^ a-zA-Z0-9_.-]+)/n) do
      '%' + $1.unpack('H2' * $1.size).join('%').upcase
    end.tr(' ', '-')
  end
  
  def icon
    medias.first.icon
  end
  
  def title
    return self.name
  end
  
  def original_medias(sorted = true)
    originals = self.medias.select{|media| media.original?}
    originals.sort! {|x,y| x.position <=> y.position } if sorted
    originals
  end
  
  # =====
  #
  # Permissions
  #
  # =====
  
  def is_public?
    self.permissions.empty?
  end
  
  def is_private?
    !self.is_public?
  end
  
  def set_permission(user_id)
    self.permissions.create :user_id => user_id
  end
  
  def is_allowed?(user_id)
    !MediaRocket::GalleryPermission.first(:gallery_id => self, :user_id => user_id).nil?
  end
end
