class MediaRocket::CategoryController < MediaRocket::Application
  provides :xml
  
  def list
    @categories = MediaRocket::Category.all
    render :layout => false
  end
  
  def gallery
    return nil if params[:id].nil?
    @category = MediaRocket::Category.first(:id => params[:id])
    @medias = @category.medias.select{|media| media.original?}
    @medias.sort! {|x,y| x.position <=> y.position }
    render :layout => false
  end
  
end
