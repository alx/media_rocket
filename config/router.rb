Merb::Router.prepare do
  # Upload route
  match('/upload').to(:controller => 'main', :action => 'upload').name(:upload)
  # Route with tags and format
  match('/:tags(.:format)').to(:controller => 'main', :action => 'list').name(:list)
  # Route with file serial
  match('/file/:id').to(:controller => 'main', :action => 'show').name(:show)
  
  match('/').to(:controller => 'main', :action => 'index').name(:index)
end