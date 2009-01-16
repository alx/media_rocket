Merb::Router.prepare do |r|
  
  r.identify :id do
    r.resources :medias, "MediaRocket::Medias"
  end
  
  r.identify :id do
    r.resources :categories, "MediaRocket::Categories"
  end
  
  # Upload route
  r.match('/upload').to(:controller => 'main', :action => 'upload').name(:upload)

  # Route with tags and format
  r.match('/galleries(.:format)').to(:controller => 'CategoryController', :action => 'list').name(:galleries)
  r.match('/gallery/:id(.:format)').to(:controller => 'CategoryController', :action => 'gallery').name(:gallery)

   # Route to front page
  r.match('/').to(:controller => 'main', :action => 'index').name(:index)
end