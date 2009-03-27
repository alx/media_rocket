class MediaRocket::Galleries < MediaRocket::Application

  if method_defined? :ensure_authenticated
    before :ensure_authenticated, :exclude => ["index", "gallery"]
  end
  
  def new
    if params[:parent_id] and params[:name]
      ::MediaRocket::Gallery.first(:id => params[:parent_id]).add_child(params[:name])
    end
    []
  end
  
  
  # GET /gallery/:id/delete
  def delete
    ::MediaRocket::Gallery.first(:id => params[:id]).destroy
    []
  end

  # DELETE /gallery/:id
  def destroy
    ::MediaRocket::Gallery.first(:id => params[:id]).destroy
    []
  end
  
  # GET /galleries
  def index
    provides :xml
    @galleries = ::MediaRocket::Gallery.all.select{|gallery| gallery.protected? == false}
    render :layout => false
  end
  
  # GET /gallery/:id/edit
  def edit
    
    # reoroder list
    if params[:media_list] && media_order = params[:media_list].split(",")
      i = 0
      media_order.each do |media_id|
        MediaRocket::MediaFile.first(:id => media_id).update_attributes(:position => i)
        i += 1
      end
    end
    
    if @gallery = ::MediaRocket::Gallery.first(:id => params[:id])
      
      params.each do |key, value|
        @gallery.update_attributes(key => value) if @gallery.attributes.key?(key.to_sym)
      end
      
      # "001122334455" is reset value for password
      if params[:password] and params[:password] != "001122334455"
        @gallery.protect params[:password]
      end
      
      display @gallery, :layout => false
    end
  end
  
  # GET /gallery/:id(.:format)
  def gallery
    provides :xml, :json, :html
    
    @gallery = ::MediaRocket::Gallery.first(:id => params[:id])
    return nil if @gallery.nil?
    
    if @gallery.protected? and !@gallery.authenticated?(params[:password])
      # Ask password to user
      render :template => 'galleries/password_request'
    else
      
      @medias = @gallery.medias.select{|media| media.original?}
      @medias.sort! {|x,y| x.position <=> y.position }

      case params[:format]
      when :json  then  display_json @medias
      when :html  then  render
      else render :layout => false
      end
    end
  end
  
  def password_request
    render
  end
  
  protected
  
    # Send the list of original media using json
    # {
    #   "Medias":
    #   [
    #     {
    #      "title": media.title, 
    #      "url": media.url,
    #      "icon": media.thumbnail || media.icon
    #     }
    #   ]
    # }
    def display_json(medias)
      JSON.pretty_generate(medias.inject(Hash.new) do |json, media|
          if media.original?
            json["medias"] = [] unless json.key?("medias")
            json["medias"] << {:title => media.title, 
                               :url => media.url, 
                               :icon => media.icon, 
                               :mime => media.mime}
          end
          json
        end
      )
    end
  
end
