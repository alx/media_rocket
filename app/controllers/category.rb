class MediaRocket::Categories < MediaRocket::Application
  provides :xml
  
  def new
    if params[:parent_id] and params[:name]
      MediaRocket::Gallery.first(:id => params[:parent_id]).add_child(params[:name])
    end
  end
  
  def list
    @categories = MediaRocket::Gallery.all
    render :layout => false
  end
  
  def gallery
    return nil if params[:id].nil?
    @category = MediaRocket::Gallery.first(:id => params[:id])
    @medias = @category.medias.select{|media| media.original?}
    @medias.sort! {|x,y| x.position <=> y.position }
    render :layout => false
  end
  
end
