Merb::Router.prepare do |scope|
  scope.identify DataMapper::Resource => :id do |s|
    s.resources :medias, "MediaRocket::Medias"
    s.resources :galleries, "MediaRocket::Galleries"
  end
  
  # Upload route
  scope.match('/upload').to(:controller => 'main', :action => 'upload').name(:upload)
  
  # Route to gallery xml
  scope.match('/galleries(.:format)').to(:controller => 'galleries', :action => 'list').name(:galleries)
  scope.match(%r[/gallery/(\d+)-.*\.(.*$)]).to(:controller => 'galleries', :action => 'gallery', :id => "[1]", :format => "[2]").name(:gallery)
  
  # Route to front page
  scope.match('/').to(:controller => 'main', :action => 'index').name(:index)
  scope.match('/manage').to(:controller => 'main', :action => 'list').name(:manage)
end