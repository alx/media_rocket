class MediaRocket::Main < MediaRocket::Application
  provides :html, :xml, :json
  
  def index
    render
  end
  
  def upload
    MediaRocket::Media.new(params).save
    redirect (params[:redirect_to] || "/")
  end
  
  def list
    @sites = MediaRocket::Site.all
    render
  end
  
  def show
    if params[:id]
      media = MediaRocket::Media.first(:id => params[:id])
      display media.path
    end
  end
  
end