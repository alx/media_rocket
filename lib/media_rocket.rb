if defined?(Merb::Plugins)

  $:.unshift File.dirname(__FILE__)

  dependency 'merb-slices'
  Merb::Plugins.add_rakefiles "media_rocket/tasks/merbtasks", "media_rocket/tasks/slicetasks"

  # Register the Slice for the current host application
  Merb::Slices::register(__FILE__)
  
  # Slice configuration - set this in a before_app_loads callback.
  # By default a Slice uses its own layout, so you can swicht to 
  # the main application layout or no layout at all if needed.
  # 
  # Configuration options:
  # :layout - the layout to use; defaults to :media_rocket
  # :mirror - which path component types to use on copy operations; defaults to all
  Merb::Slices::config[:media_rocket][:layout] ||= :media_rocket
  
  # All Slice code is expected to be namespaced inside a module
  module MediaRocket
    
    # Slice metadata
    self.description = "MediaRocket is a media server to upload and retrieve all kind of media!"
    self.version = "1.1.0"
    self.author = "Legodata"
    
    # Stub classes loaded hook - runs before LoadClasses BootLoader
    # right after a slice's classes have been loaded internally.
    def self.loaded
      require "media_rocket/helpers"
      Helpers.setup
    end
    
    # Initialization hook - runs before AfterAppLoads BootLoader
    def self.init
    end
    
    # Activation hook - runs after AfterAppLoads BootLoader
    def self.activate
    end
    
    # Deactivation hook - triggered by Merb::Slices.deactivate(MediaRocket)
    def self.deactivate
    end
    
    # Setup routes inside the host application
    #
    # @param scope<Merb::Router::Behaviour>
    #  Routes will be added within this scope (namespace). In fact, any 
    #  router behaviour is a valid namespace, so you can attach
    #  routes at any level of your router setup.
    #
    # @note prefix your named routes with :media_rocket_
    #   to avoid potential conflicts with global named routes.
    def self.setup_router(scope)
      ::MediaRocket::Router.setup(scope)
    end
    
  end
  
  # Setup the slice layout for MediaRocket
  #
  # Use MediaRocket.push_path and MediaRocket.push_app_path
  # to set paths to media_rocket-level and app-level paths. Example:
  #
  # MediaRocket.push_path(:application, MediaRocket.root)
  # MediaRocket.push_app_path(:application, Merb.root / 'slices' / 'media_rocket')
  # ...
  #
  # Any component path that hasn't been set will default to MediaRocket.root
  #
  # Or just call setup_default_structure! to setup a basic Merb MVC structure.
  MediaRocket.setup_default_structure!
  
  # Add dependencies for other MediaRocket classes below. Example:
  # dependency "media_rocket/other"
  
  use_orm :datamapper
  
  merb_version = ">= 1.0.7.1"
  
  dependency 'merb-assets',               merb_version
  dependency 'merb-helpers',              merb_version
  dependency 'merb_datamapper',           merb_version
  dependency 'merb-builder',              ">= 0.9.8"
  dependency "merb-mailer",               merb_version
  dependency "merb-param-protection",     merb_version
  dependency "merb-exceptions",           merb_version
  
  dm_version   = ">= 0.9.9"
  
  dependency "dm-core",         dm_version         
  dependency "dm-aggregates",   dm_version   
  dependency "dm-migrations",   dm_version   
  dependency "dm-timestamps",   dm_version   
  dependency "dm-types",        dm_version        
  dependency "dm-validations",  dm_version
  dependency "dm-tags",         dm_version
  dependency "dm-is-tree",      dm_version
  
  # Various mixins and classes
  require "media_rocket/router"
  
  require "RMagick"
  require "base64"
  
end