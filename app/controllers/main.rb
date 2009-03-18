class MediaRocket::Main < MediaRocket::Application
  provides :html, :xml, :json
  
  before :ensure_authenticated, :only => [:upload]
  
  def index
    render
  end
  
  def upload
    ::MediaRocket::MediaFile.new(params).save
    redirect (params[:redirect_to] || "/")
  end
  
end