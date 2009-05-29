class MediaRocket::Galleries < MediaRocket::Application

  if method_defined? :ensure_authenticated
    before :ensure_authenticated, :exclude => ["index", "gallery"]
  end
  
  def new
    if params[:parent_id] and params[:name]
      ::MediaRocket::Gallery.first(:id => params[:parent_id]).add_child(params[:name])
    end
    []
  end
  
  
  # GET /gallery/:id/delete
  def delete
    ::MediaRocket::Gallery.first(:id => params[:id]).destroy
    []
  end

  # DELETE /gallery/:id
  def destroy
    ::MediaRocket::Gallery.first(:id => params[:id]).destroy
    []
  end
  
  # GET /galleries
  def index
    provides :xml, :json
    @galleries = ::MediaRocket::Site.first.galleries.select{|gallery| gallery.parent.nil?}
    
    case params[:format]
      when "json"  then  build_galleries_json @galleries
      when "xml"   then  render :layout => false
      else  render
    end
  end
  
  def create
    provides :json
    
    unless params[:gallery][:parent_id].empty?
      # If parent gallery is specified, fetch it and add a child with name params
      parent = ::MediaRocket::Gallery.first(:id => params[:gallery][:parent_id])
      gallery = parent.add_child(params[:gallery][:name])
    else
      # Otherwise, simply create a new gallery with current parameters (name and site_id)
      gallery = ::MediaRocket::Gallery.create(params[:gallery])
    end
    
    build_galleries_json([gallery])
  end
  
  # GET /gallery/:id/edit
  def edit
    
    if @gallery = ::MediaRocket::Gallery.first(:id => params[:id])
      
      params.each do |key, value|
        @gallery.update_attributes(key => value) if @gallery.attributes.key?(key.to_sym)
      end
      
      display @gallery, :layout => false
    end
  end
  
  # GET /gallery/:id(.:format)
  def gallery
    provides :xml, :json, :html
    
    if params[:id] == "first"
      @gallery = ::MediaRocket::Gallery.first
    else
      @gallery = ::MediaRocket::Gallery.first(:id => params[:id])
    end
    return nil if @gallery.nil? || @gallery.is_private?
    
    @medias = @gallery.original_medias

    case params[:format]
      when "json"  then  build_json(@gallery)
      when "xml"   then  render :layout => false
      else  render
    end
  end
  
  # PUT /galleries/:id
  def update
    @gallery = MediaRocket::Gallery.first(:id => params[:id])
    raise NotFound unless @gallery
    
    # reoroder list
    if params[:media_list] && media_order = params[:media_list].split(",")
      i = 0
      media_order.each do |media_id|
        MediaRocket::MediaFile.first(:id => media_id).update_attributes(:position => i)
        i += 1
      end
    end
    
    # Reformat parameters that could contain special chars
    params[:gallery][:name]         = Base64.decode64(params[:gallery][:name]) if params[:gallery][:name]
    params[:gallery][:description]  = Base64.decode64(params[:gallery][:description]) if params[:gallery][:description]
    params[:gallery][:ref_title]    = Base64.decode64(params[:gallery][:ref_title]) if params[:gallery][:ref_title]
    params[:gallery][:ref_meta]     = Base64.decode64(params[:gallery][:ref_meta]) if params[:gallery][:ref_meta]
    
    @gallery.update_attributes(params[:gallery]) if params[:gallery]
    
    build_json(@gallery)
  end
  
  protected
  
    # Send the list of original media using json
    # {
    #   "Medias":
    #   [
    #     gallery:
    #     { 
    #       "id": gallery.id, 
    #       "title": gallery.title,
    #       "icon": gallery.icon
    #     },
    #     galleries:
    #     {
    #       { 
    #         "id": gallery.children[0].id, 
    #         "title": gallery.children[0].title,
    #         "icon": gallery.children[0].icon
    #       },
    #       ...
    #     }
    #     medias:
    #     {
    #       { 
    #         "title": gallery.original_medias[0].title, 
    #         "url": gallery.original_medias[0].url,
    #         "icon": gallery.original_medias[0].thumbnail || media.icon
    #       },
    #       ...
    #     }
    #   ]
    # }
    def build_galleries_json(galleries)
      if galleries.empty?
        return ""
      else
        json = '{"galleries": ['
        galleries.each do |gallery|
          json << (gallery.to_json << ', ')
        end
        json.gsub!(/,$/, '')
        json << "]}"
        json
      end
    end
    
    def build_json(gallery)
      
      medias = gallery.original_medias
      children_galleries = gallery.children
      
      json = '{"gallery": ' << gallery.to_json
      
      unless children_galleries.empty?
        json << ', "galleries": ['
        children_galleries.each do |gallery|
          json << (gallery.to_json << ', ')
        end
        json.gsub!(/,$/, '')
        json << "]"
      end
      
      unless medias.empty?
        json << ', "medias": ['
        medias.each do |media|
          json << (media.to_json << ', ')
        end
        json.gsub!(/,$/, '')
        json << "]"
      end
      
      json << '}'
    end
        
    
end
