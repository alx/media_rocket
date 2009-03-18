class MediaRocket::Medias < MediaRocket::Application

  #before :ensure_authenticated, :exclude => [:index, :show]

  def index
    provides :json
    @medias = ::MediaRocket::MediaFile.all(:gallery_id => params[:gallery_id])
    
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
  end

  def show
    @media = ::MediaRocket::MediaFile.first(:id => params[:id])
    render :layout => false
  end

  # GET /medias/:id/edit
  def edit
    if @media = ::MediaRocket::MediaFile.first(:id => params[:id])
      
      params.each do |key, value|
        @media.update_attributes(key => value) if @media.attributes.key?(key.to_sym)
      end
      
      display @media, :layout => false
    end
  end

  # GET /medias/:id/delete
  def delete
    ::MediaRocket::MediaFile.first(:id => params[:id]).destroy
    []
  end

  # DELETE /medias/:id
  def destroy
    ::MediaRocket::MediaFile.first(:id => params[:id]).destroy
    []
  end
end
