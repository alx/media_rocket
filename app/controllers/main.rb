class MediaRocket::Main < MediaRocket::Application
  provides :html, :xml, :json
  
  if method_defined? :ensure_authenticated
    #before :ensure_authenticated, :only => ["upload"]
  end
  
  def index
    render
  end
  
  def upload
    if params[:Filedata]
      
      if @site = ::MediaRocket::Site.first(:id => params[:site_id])
      
        media_params = {:title => params[:Filename],
                        :site_id => @site.id,
                        :gallery_name => params[:gallery_name],
                        :gallery_id => params[:gallery_id],
                        :file => {:filename => params[:Filename],
                                  :tempfile => params[:Filedata][:tempfile]}}
                                  
        @media = ::MediaRocket::MediaFile.new(media_params)
        @media.save
        
      end # @site = ...
      
      # Return 1 for success in uploadify
      render "1", :layout => false
    else
      ::MediaRocket::MediaFile.new(params).save
      redirect (params[:redirect_to] || "/")
    end
  end
  
end