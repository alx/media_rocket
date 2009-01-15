class MediaRocket::Medias < MediaRocket::Application

  # GET /media/:id/edit
  def edit
    MediaRocket::MediaFile.first(:id => params[:id]).update_attributes params
  end

  # GET /media/:id/delete
  def delete
    MediaRocket::MediaFile.first(:id => params[:id]).destroy
  end

  # PUT /media/:id
  def update
    MediaRocket::MediaFile.first(:id => params[:id]).update_attributes params
  end

  # DELETE /media/:id
  def destroy
    MediaRocket::MediaFile.first(:id => params[:id]).destroy
  end
end
