class MediaRocket::Medias < MediaRocket::Application

  if method_defined? :ensure_authenticated
    before :ensure_authenticated
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
  
  # PUT /galleries/:id
  def update
    @media = MediaRocket::MediaFile.first(:id => params[:id])
    raise NotFound unless @media
    
    if params[:media]
      params[:media][:name] = Base64.decode64(params[:media][:name]) if params[:media][:name]
      @media.update_attributes(params[:media]) 
    end
    
    @media.to_json
  end
end
