module MediaRocket
  module Router
    
    def self.setup(scope)
      # Upload route
      scope.match('/upload').to(:controller => 'main', :action => 'upload').name(:upload)
      # Route with tags and format
      scope.match('/:tags(.:format)').to(:controller => 'main', :action => 'list').name(:home)
      # Route with file serial
      scope.match('/file/:id').to(:controller => 'main', :action => 'show').name(:show)
      
      scope.match('/').to(:controller => 'main', :action => 'index').name(:index)
      # enable slice-level default routes by default
      scope.default_routes
    end
    
  end
end