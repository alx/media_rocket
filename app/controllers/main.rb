class MediaRocket::Main < MediaRocket::Application
  provides :html, :xml, :json
  
  def index
    render
  end
  
  def upload
    MediaRocket::MediaFile.new(params).save
    redirect (params[:redirect_to] || "/")
  end
  
end