class MediaRocket::Main < MediaRocket::Application
  provides :html, :xml, :json
  
  if method_defined? :ensure_authenticated
    #before :ensure_authenticated, :only => ["upload"]
  end
  
  def index
    render
  end
  
  def upload
    
    json = "-1"
    
    if @site = ::MediaRocket::Site.first
      
      title = params[:title].empty? ? params[:file][:filename] : params[:title]
      
      # Prepare params for media_file
      media_params = {:title => title,
                      :site_id => @site.id,
                      :gallery_id => params[:gallery_id],
                      :file => {:filename => params[:file][:filename],
                                :tempfile => params[:file][:tempfile]}}
                                
      if params[:Filedata]
        # Upload made with uploadify, modify some params
        # FIXME: tell uploadify to send standard param
        Merb.logger.debug "upload with uploadify"
        media_params[:file][:filename] = params[:Filename]
        media_params[:file][:tempfile] = params[:Filename][:tempfile]
      end
      
      @media = ::MediaRocket::MediaFile.new(media_params)
      
      if @media.save
        # Return information after success
        json = @media.to_json
      end
    end # @site = ...
    
    render json, :layout => false
  end
  
  private 
  
  def param_unescape(string)
    string.tr('+', ' ').gsub(/((?:%[0-9a-fA-F]{2})+)/n) do
      [$1.delete('%')].pack('H*')
    end
  end
  
end