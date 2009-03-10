class MediaRocket::Galleries < MediaRocket::Application
  
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
      
      display @gallery, :layout => false
    end
  end
  
  def gallery
    provides :xml
    return nil if params[:id].nil?
    @gallery = ::MediaRocket::Gallery.first(:id => params[:id])
    @medias = @gallery.medias.select{|media| media.original?}
    @medias.sort! {|x,y| x.position <=> y.position }
    render :layout => false
  end
  
end
