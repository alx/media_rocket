class MediaRocket::Main < MediaRocket::Application
  provides :html, :xml, :json
  
  if method_defined? :ensure_authenticated
    #before :ensure_authenticated, :only => ["upload"]
  end
  
  def index
    render
  end
  
  def upload
    
    if @site = ::MediaRocket::Site.first(:id => params[:site_id])
        
      if params[:Filedata]
        # Upload with uploadify
        media_params = {:title => params[:Filename],
                        :site_id => @site.id,
                        :gallery_id => params[:gallery_id],
                        :file => {:filename => params[:Filename],
                                  :tempfile => params[:Filedata][:tempfile]}}
      else
        # Upload one by one
        media_params = {:title => params[:title] || params[:filename],
                        :site_id => @site.id,
                        :gallery_id => params[:gallery_id],
                        :file => {:filename => params[:filename],
                                  :tempfile => params[:tempfile]}}
      end
      
      @media = ::MediaRocket::MediaFile.new(media_params)
        
      if @media.save
        # Return information after success in uploadify
        render JSON.pretty_generate(["medias" => {:icon => @media.icon, 
                                                  :media_id => @media.id, 
                                                  :name => @media.title}]), :layout => false
      end # @media.save
        
    end # @site = ...
      
    # Upload unsuccessful
    # render "-1", :layout => false
    render JSON.pretty_generate(["medias" => {}]), :layout => false
  end
  
  private 
  
  def param_unescape(string)
    string.tr('+', ' ').gsub(/((?:%[0-9a-fA-F]{2})+)/n) do
      [$1.delete('%')].pack('H*')
    end
  end
  
end