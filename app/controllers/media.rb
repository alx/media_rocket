class MediaRocket::Medias < MediaRocket::Application

  # GET /medias/:id/edit
  def edit
    if media = MediaRocket::MediaFile.first(:id => params[:id])
      params.each do |key, value|
        media.update_attributes(key => value) if media.attributes.key?(key.to_sym)
      end
    end
    []
  end

  # GET /medias/:id/delete
  def delete
    MediaRocket::MediaFile.first(:id => params[:id]).destroy
    []
  end

  # PUT /medias/:id
  def update
    if media = MediaRocket::MediaFile.first(:id => params[:id])
      params.each do |key, value|
        media.update_attributes(key => value) if media.attributes.key?(key.to_sym)
      end
    end
    []
  end

  # DELETE /medias/:id
  def destroy
    MediaRocket::MediaFile.first(:id => params[:id]).destroy
    []
  end
end
