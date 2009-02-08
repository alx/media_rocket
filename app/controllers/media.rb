class MediaRocket::Medias < MediaRocket::Application

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
