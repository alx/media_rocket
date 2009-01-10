class MediaRocket::Main < MediaRocket::Application
  provides :html, :xml, :json
  
  def index
    render
  end
  
  def upload
    @media = MediaRocket::Media.new :file => params[:file], 
                                    :tags => params[:tags],
                                    :delimiter => params[:delimiter] || '+'
    @media.save
    redirect "/"
  end
  
  def list
    @delimiter = params[:delimiter] || '+'
    @tags = params[:tags]
    if params[:tags]
      @medias = []
      params[:tags].split(delimiter).each { |tag| @medias << MediaRocket::Media.tagged_with(tag) }
      @medias.uniq!
    else
      @medias = MediaRocket::Media.all
    end
    display @medias
  end
  
  def show
    if params[:id]
      render MediaRocket::Media.first :id => params[:id]
    end
  end
  
end