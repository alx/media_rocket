class MediaRocket::Permissions < MediaRocket::Application
  
  before :user_defined
  before :ensure_admin
  
  #
  # Verify User class is defined,
  # it won't be able to apply permission without it
  #
  def user_defined
    !(defined?(User).nil?)
  end
  
  #
  # Verify current authenticated user is admin
  #
  def ensure_admin
    session.authenticate!(request, params) unless session.authenticated?
    session[:user] == 1
  end
  
  
  def edit
    @gallery = ::MediaRocket::Gallery.first(:id => params[:gallery_id])
    @users = User.all
    @users.shift
  end
  
  def index
    
    if params[:permission_act]
      
      case params[:permission_act]
        when "add_user" then add_user(params)
        when "rem_user" then remove_user(params)
        when "add_perm" then add_gallery_permission_to_user(params)
        when "rem_perm" then remove_gallery_permission_to_user(params)
      end
    
    end
      
    @users = User.all
    @users.shift # Do not fetch admin User
    render
      
  end
  
  protected
  
  def add_user(params)
    Merb.logger.info "add_user"
    if params[:login] && params[:password]
      u = User.new(:login => params[:login])
      u.password = u.password_confirmation = params[:password]
      u.save
    end
  end
  
  def remove_user(params)
    Merb.logger.info "remove_user"
    if params[:user_id] && user = User.first(:id => params[:user_id])
      user.destroy
    end
  end
  
  def add_gallery_permission_to_user(params)
    Merb.logger.info "add_gallery_permission_to_user"
    if params[:user_id] && params[:gallery_id] && gallery = MediaRocket::Gallery.first(:id => params[:gallery_id])
      gallery.set_permission params[:user_id]
    end
  end
  
  def remove_gallery_permission_to_user(params)
    Merb.logger.info "remove_gallery_permission_to_user"
    if params[:perm_id] && perm = MediaRocket::GalleryPermission.first(params[:perm_id])
      perm.destroy
    end
  end
  
end