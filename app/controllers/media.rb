class MediaRocket::MediaController < Application

  # GET /media/:id/edit
  def edit
    MediaRocket::Media.first(:id => params[:id]).update_attributes params
  end

  # GET /media/:id/delete
  def delete
    @media = MediaRocket::Media.first(:id => params[:id])
    @site = @media.site
    @category = @media.category
    
    @media.destroy
    @site.reload
    @category.reload
  end

  # PUT /media/:id
  def update
    MediaRocket::Media.first(:id => params[:id]).update_attributes params
  end

  # DELETE /media/:id
  def destroy
    @media = MediaRocket::Media.first(:id => params[:id])
    @site = @media.site
    @category = @media.category
    
    @media.destroy
    @site.reload
    @category.reload
  end
end
