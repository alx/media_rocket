module MediaRocket
  module Router
    
    def self.setup(scope)
      
      scope.identify :id do
        resources :medias
      end
      
      # Upload route
      scope.match('/upload').to(:controller => 'main', :action => 'upload').name(:upload)
      
      # Route with file serial
      scope.match(/\/file\/(.*)?/).to(:controller => 'main', :action => 'show', :id => "[1]").name(:show)

      # Route to gallery xml
      scope.match('/galleries(.:format)').to(:controller => 'CategoryController', :action => 'list').name(:galleries)
      scope.match('/gallery/:id(.:format)').to(:controller => 'CategoryController', :action => 'gallery').name(:gallery)
      
      # Route to front page
      scope.match('/').to(:controller => 'main', :action => 'index').name(:index)
      scope.match('/manage').to(:controller => 'main', :action => 'list').name(:manage)
    end
    
  end
end