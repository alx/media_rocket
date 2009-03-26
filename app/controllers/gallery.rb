class MediaRocket::Galleries < MediaRocket::Application

  before :ensure_authenticated, :exclude => ["index", "gallery"]
  
  def new
    if params[:parent_id] and params[:name]
      ::MediaRocket::Gallery.first(:id => params[:parent_id]).add_child(params[:name])
    end
    []
  end
  
  
  # GET /media/:id/delete
  def delete
    ::MediaRocket::Gallery.first(:id => params[:id]).destroy
    []
  end

  # DELETE /media/:id
  def destroy
    ::MediaRocket::Gallery.first(:id => params[:id]).destroy
    []
  end
  
  # GET /galleries
  def index
    provides :xml
    @galleries = ::MediaRocket::Gallery.all
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
  
  def gallery
    provides :xml, :json
    return nil if params[:id].nil?
    @gallery = ::MediaRocket::Gallery.first(:id => params[:id])
    @medias = @gallery.medias.select{|media| media.original?}
    @medias.sort! {|x,y| x.position <=> y.position }
    
    
    if params[:format] == "json"
      # Send the list of original media using json
      # {
      #   "Medias":
      #   [
      #     {"title": media.title, "url": media.url, "icon": media.thumbnail || media.icon}
      #   ]
      # }
      JSON.pretty_generate( @medias.inject(Hash.new) do |json, media|
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
    elsif params[:format] == "xml"
      # Render xml
      render :layout => false
    end
  end
  
end
