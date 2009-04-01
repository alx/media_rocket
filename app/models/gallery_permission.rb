class MediaRocket::GalleryPermission
  include DataMapper::Resource
  
  property :id, Serial
  property :user_id, Integer
  property :level, Integer
  
  #
  # Levels
  #
  # Wordpress codex brings a nice documentation about levels that could be use:
  # http://codex.wordpress.org/Roles_and_Capabilities
  #
  # * User Level 0 converts to Subscriber Role
  # * User Level 1 converts to Contributor Role
  # * User Level 2 converts to Author Role
  # * User Level 3 converts to Author Role
  # * User Level 4 converts to Author Role
  # * User Level 5 converts to Editor Role
  # * User Level 6 converts to Editor Role
  # * User Level 7 converts to Editor Role
  # * User Level 8 converts to Administrator Role
  # * User Level 9 converts to Administrator Role
  # * User Level 10 converts to Administrator Role
  
  belongs_to :gallery, :class_name => ::MediaRocket::Gallery, :child_key => [:gallery_id]
  
end