class MediaRocket::Medias < MediaRocket::Application

  # GET /media/:id/edit
  def edit
    if media = MediaRocket::MediaFile.first(:id => params[:id])
      media.update_attributes :title => params[:title],
                              :description => params[:description]
    end
    []
  end

  # GET /media/:id/delete
  def delete
    MediaRocket::MediaFile.first(:id => params[:id]).destroy
    []
  end

  # PUT /media/:id
  def update
    if media = MediaRocket::MediaFile.first(:id => params[:id])
      media.update_attributes :title => params[:title],
                              :description => params[:description]
    end
    []
  end

  # DELETE /media/:id
  def destroy
    MediaRocket::MediaFile.first(:id => params[:id]).destroy
    []
  end
end
