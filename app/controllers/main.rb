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
      
      if @site = ::MediaRocket::Site.first(:id => params[:site_id])
      
        media_params = {:title => params[:Filename],
                        :site_id => params[:site_id],
                        :file => {:filename => params[:Filename],
                                  :tempfile => params[:Filedata][:tempfile]}}
        @media = ::MediaRocket::MediaFile.new(media_params)
      
        # Save media and insert it into gallery
        if @media.save
        
          @site.reload
        
          if !params[:gallery_name].empty?
            # gallery name specified, use it as media gallery
            unless @gallery = ::MediaRocket::Gallery.first(:name => params[:gallery_name])
              @gallery = @site.galleries.create :name => params[:gallery_name]
            end
          else
            # use gallery from select box if no gallery specified
            @gallery = ::MediaRocket::Gallery.first :id => params[:gallery_id]
          end # !params[:gallery_name].empty?
          
          @gallery.medias << @media
          @gallery.medias.reload
          
        end # @media.save
      end # @site = ...
      # Return 1 for success in uploadify
      render "1", :layout => false
    else
      ::MediaRocket::MediaFile.new(params).save
      redirect (params[:redirect_to] || "/")
    end
  end
  
end