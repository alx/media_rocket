Merb::Router.prepare do |scope|
  
  scope.identify DataMapper::Resource => :id do |s|
    s.resources :medias, "MediaRocket::Medias"
    s.resources :categories, "MediaRocket::Categories"
  end
  
  # Upload route
  scope.match('/upload').to(:controller => 'main', :action => 'upload').name(:upload)
  
  # Queue route
  scope.match('/queue').to(:controller => 'queue', :action => 'index').name(:queue)
  scope.match('/select_files').to(:controller => 'queue', :action => 'select_files').name(:select_files)
  scope.match('/batch_edit').to(:controller => 'queue', :action => 'batch_edit').name(:batch_edit)
  
  # Route to gallery xml
  scope.match('/galleries(.:format)').to(:controller => 'categories', :action => 'list').name(:galleries)
  scope.match('/gallery/:id(.:format)').to(:controller => 'categories', :action => 'gallery').name(:gallery)
  
  # Route to front page
  scope.match('/').to(:controller => 'main', :action => 'index').name(:index)
  scope.match('/manage').to(:controller => 'main', :action => 'list').name(:manage)
end