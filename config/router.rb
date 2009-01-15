Merb::Router.prepare do |r|
  
  r.identify :id do
    r.resources :medias
  end
  
  # Upload route
  r.match('/upload').to(:controller => 'main', :action => 'upload').name(:upload)

  # Route with file name
  r.match(/\/file\/(.*)?/).to(:controller => 'main', :action => 'show', :id => "[1]").name(:show)

  # Route with tags and format
  r.match('/galleries(.:format)').to(:controller => 'CategoryController', :action => 'list').name(:galleries)
  r.match('/gallery/:id(.:format)').to(:controller => 'CategoryController', :action => 'gallery').name(:gallery)

   # Route to front page
  r.match('/').to(:controller => 'main', :action => 'index').name(:index)
  r.match('/manage').to(:controller => 'main', :action => 'list').name(:manage)
end