Merb::Router.prepare do |scope|
  scope.identify DataMapper::Resource => :id do |s|
    s.resources :sites, ::MediaRocket::Medias do |r|
      r.resources :medias, ::MediaRocket::Medias
      r.resources :galleries, ::MediaRocket::Galleries do |p|
        p.resources :medias, ::MediaRocket::Medias
      end
    end  
    s.resources :galleries, ::MediaRocket::Galleries do |r|
      r.resources :medias, ::MediaRocket::Medias
    end
    s.resources :medias, ::MediaRocket::Medias
  end
  
  # Upload route
  scope.match('/upload').to(:controller => 'main', :action => 'upload').name(:upload)
  
  # Route to gallery xml
  scope.match('/galleries(.:format)').to(:controller => 'galleries', :action => 'list').name(:galleries)
  scope.match('/gallery/:id(.:format)').to(:controller => 'galleries', :action => 'gallery').name(:gallery)
  
  # Route to front page
  scope.match('/').to(:controller => 'main', :action => 'index').name(:index)
  scope.match('/manage').to(:controller => 'main', :action => 'list').name(:manage)
end