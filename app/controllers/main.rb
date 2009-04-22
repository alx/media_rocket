class MediaRocket::Main < MediaRocket::Application
  provides :html, :xml, :json
  
  if method_defined? :ensure_authenticated
    before :ensure_authenticated, :only => ["upload"]
  end
  
  def index
    render
  end
  
  def upload
    if params[:Filedata]
      Merb.logger.info "filedata read"
      
      media_params = {:title => params[:Filename],
                      :site_id => params[:site_id],
                      :file => {:filename => params[:Filename],
                                :tempfile => params[:Filedata][:tempfile]}}
      ::MediaRocket::MediaFile.new(media_params).save
      
      # Return 1 for success in uploadify
      render "1", :layout => false
    else
      ::MediaRocket::MediaFile.new(params).save
      redirect (params[:redirect_to] || "/")
    end
  end
  
end