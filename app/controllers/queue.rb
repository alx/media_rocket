class MediaRocket::Queue < MediaRocket::Application
  layout :queue
  
  before :ensure_authenticated
  
  def index
    
    redirect slice_url(:select_files) if params[:select_files]
    # if params[:clear_queue]
    # if params[:publish_all]
    # if params[:publish_first]
    
    @queue = []
    render
  end
  
  def select_files
    @site = ::MediaRocket::Site.first
    render
  end
  
  def batch_edit
    render
  end
end
