class MediaRocket::Gallery
  include DataMapper::Resource
  
  property :id, Serial
  property :parent_id, Integer
  property :name, String
  property :description, Text
  property :ref_title, Text
  property :ref_meta, Text
  
  property :crypted_password, Text, :default => ""
  property :salt, Text, :default => Digest::SHA1.hexdigest("--#{Time.now.to_s}--")
  
  has_tags
  
  is_tree :order => "id"
  
  belongs_to :site, :class_name => "MediaRocket::Site"
  has n, :medias, :class_name => "MediaRocket::MediaFile"
  
  before :destroy, :clean_gallery

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
  
  # =====
  #
  # Protection
  #
  # =====
  
  # Verify if the current gallery is protected
  def protected?
    return !self.crypted_password.strip.empty?
  end
  
  # Protect or remov protection on the gallery
  def protect(password)
    if password.strip.empty?
      self.update_attributes :crypted_password => ""
    else
      self.update_attributes :crypted_password => encrypt(password)
    end
  end
  
  # Verify that the password givn correspond to the gallery
  def authenticated?(password)
    self.crypted_password == encrypt(password)
  end
  
  # Encrypts some data with the salt.
  def encrypt(password)
    Digest::SHA1.hexdigest("--#{self.salt}--#{password}--")
  end
  
  # Salt the current gallery
  def create_salt
    self.update_attributes :salt => Digest::SHA1.hexdigest("--#{Time.now.to_s}--")
  end
end
