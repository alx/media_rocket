class MediaRocket::Widget < MediaRocket::Application
  provides :html, :xml, :json
  layout :false
  
  def gallery_builder
    @site = ::MediaRocket::Site.first
    render :layout => false
  end
  
end