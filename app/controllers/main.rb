class MediaRocket::Main < MediaRocket::Application
  provides :html, :xml, :json
  
  if method_defined? :ensure_authenticated
    before :ensure_authenticated, :only => ["upload"]
  end
  
  def index
    render
  end
  
  def upload
    ::MediaRocket::MediaFile.new(params).save
    redirect (params[:redirect_to] || "/")
  end
  
end