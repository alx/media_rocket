module MediaRocket
  module Router
    
    def self.setup(scope)

      scope.identify DataMapper::Resource => :id do |s|
        s.resources :sites, ::MediaRocket::Medias do |r|
          r.resources :medias, ::MediaRocket::Medias
          r.resources :galleries, ::MediaRocket::Galleries do |p|
            p.resources :medias, ::MediaRocket::Medias
            p.resources :permissions, ::MediaRocket::Permissions
          end
        end  
        s.resources :galleries, ::MediaRocket::Galleries do |r|
          r.resources :medias, ::MediaRocket::Medias
          r.resources :permissions, ::MediaRocket::Permissions
        end
        s.resources :medias, ::MediaRocket::Medias
      end

      # Upload route
      scope.match('/upload').to(:controller => 'main', :action => 'upload').name(:upload).fixatable

      # Route to gallery xml
      scope.match('/galleries/:action/:id').to(:controller => 'galleries', :action => 'destroy').name(:delete_galleries)
      scope.match('/galleries(.:format)').to(:controller => 'galleries', :action => 'list').name(:galleries)
      scope.match('/gallery/:id(.:format)').to(:controller => 'galleries', :action => 'gallery').name(:gallery)
      scope.match('/gallery_icon').to(:controller => 'galleries', :action => 'update').name(:gallery_icon)

      # Route to permission page
      scope.match('/permissions').to(:controller => 'permissions', :action => 'index').name(:permissions)

      # Route to front page
      scope.match('/').to(:controller => 'main', :action => 'index').name(:index)

    end
    
  end
end