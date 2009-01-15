class MediaRocket::Main < MediaRocket::Application
  provides :html, :xml, :json
  
  def index
    render
  end
  
  def upload
    MediaRocket::MediaFile.new(params).save
    redirect (params[:redirect_to] || "/")
  end
  
  def list
    @sites = MediaRocket::Site.all
    render
  end
  
  def show
    if params[:id]
      media = MediaRocket::MediaFile.first(:id => params[:id])
      display media.path
    end
  end
  
end