class MediaRocket::Medias < MediaRocket::Application

  # GET /medias/:id/edit
  def edit
    if media = MediaRocket::MediaFile.first(:id => params[:id])
      media.update_attributes :title => params[:title],
                              :description => params[:description]
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
      media.update_attributes :title => params[:title],
                              :description => params[:description]
    end
    []
  end

  # DELETE /medias/:id
  def destroy
    MediaRocket::MediaFile.first(:id => params[:id]).destroy
    []
  end
end
