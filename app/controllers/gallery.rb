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
      
      if params[:password]
        @gallery.protect params[:password]
      end
      
      display @gallery, :layout => false
    end
  end
  
  # GET /gallery/:id(.:format)
  def gallery
    provides :xml, :json, :html
    return nil if params[:id].nil?
    
    @gallery = ::MediaRocket::Gallery.first(:id => params[:id])
    
    if @gallery.protected?
      # Ask password to user
      # if password not included in request or if password not correct
      redirect :password_request if !params[:password] ||
                                    @gallery.authenticated?(params[:password])
    end
    
    @medias = @gallery.medias.select{|media| media.original?}
    @medias.sort! {|x,y| x.position <=> y.position }
    
    case params[:format]
    when :json
      display_json @medias
    when :xml
      render :layout => false
    when :html
      render
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
