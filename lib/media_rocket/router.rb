module MediaRocket
  module Router
    
    def self.setup(scope)

      # scope.identify DataMapper::Resource => :id do |s|
      #   s.resources :sites, ::MediaRocket::Site do |r|
      #     r.resources :medias, ::MediaRocket::MediaFile
      #     r.resources :galleries, ::MediaRocket::Gallery do |p|
      #       p.resources :medias, ::MediaRocket::MediaFile
      #       p.resources :permissions, ::MediaRocket::GalleryPermission
      #     end
      #   end  
      #   s.resources :galleries, ::MediaRocket::Gallery do |r|
      #     r.resources :medias, ::MediaRocket::MediaFile
      #     r.resources :permissions, ::MediaRocket::GalleryPermission
      #   end
      #   s.resources :medias, ::MediaRocket::MediaFile
      # end
      
      # Route to admin page for legodata-admin
      scope.match('/gallery_builder').to(:controller => 'widget', :action => 'gallery_builder').name(:gallery_builder_admin)
      scope.match('/media_list').to(:controller => 'widget', :action => 'media_list').name(:media_list_admin)

      # Upload route
      scope.match('/upload').to(:controller => 'main', :action => 'upload').name(:upload)

      # Route to gallery xml
      scope.match('/galleries/:action/:id').to(:controller => 'galleries', :action => 'destroy').name(:delete_galleries)
      scope.match('/galleries(.:format)').to(:controller => 'galleries', :action => 'list').name(:galleries)
      scope.match('/gallery/:id(.:format)').to(:controller => 'galleries', :action => 'gallery').name(:gallery)
      scope.match('/gallery-update/:id').to(:controller => 'galleries', :action => 'update').name(:gallery_update)
      scope.match('/media-update/:id').to(:controller => 'medias', :action => 'update').name(:media_update)
      scope.match('/gallery_icon').to(:controller => 'galleries', :action => 'update').name(:gallery_icon)

      # Route to permission page
      scope.match('/permissions').to(:controller => 'permissions', :action => 'index').name(:permissions)

      # Route to front page
      scope.match('/').to(:controller => 'main', :action => 'index').name(:index)

    end
    
  end
end