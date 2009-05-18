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
    @galleries = ::MediaRocket::Site.first.galleries
    
    case params[:format]
      when "json"  then  build_galleries_json(@galleries)
      when "xml"   then  render :layout => false
      else  render
    end
  end
  
  def create
    provides :json
    @gallery = ::MediaRocket::Gallery.create(params[:gallery])
  
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
      when "json"  then  build_json(@gallery) || "123"
      when "xml"   then  render :layout => false
      else  render
    end
  end
  
  # PUT /galleries/:id
  def update
    @gallery = MediaRocket::Gallery.first(:id => params[:id])
    raise NotFound unless @gallery
    
    @gallery.update_attributes(params[:gallery]) if params[:gallery]
    
    display @layout, :edit
  end
  
  protected
  
    # Send the list of original media using json
    # {
    #   "Medias":
    #   [
    #     galleries:
    #     {
    #       { 
    #         "id": gallery.id, 
    #         "title": gallery.title,
    #         "icon": gallery.icon
    #       },
    #       ...
    #     }
    #     medias:
    #     {
    #       { 
    #         "title": media.title, 
    #         "url": media.url,
    #         "icon": media.thumbnail || media.icon
    #       },
    #       ...
    #     }
    #   ]
    # }
    
    def build_galleries_json(galleries)
      galleries_json = Hash.new
      galleries_json["galleries"] = []
    
      galleries.each do |gallery|
        galleries_json["galleries"] << {:id => gallery.id, 
                                        :name => gallery.name, 
                                        :icon => gallery.icon}
      end
    
      JSON.pretty_generate(galleries_json)
    end
    
    def build_json(gallery)
      Merb.logger.info "build json"
      
      medias = gallery.original_medias
      children_galleries = gallery.children
      
      # Use Array.inject, retrieve last state of json array and add elements to it
      #   - create empty json["galleries"] if "galleries" key doesn't exists
      #   - add new hash in array otherwise
      galleries_json = children_galleries.inject(Hash.new) do |json, gallery|
        json["galleries"] = [] unless json.key?("galleries")
        json["galleries"] << {:id => gallery.id, 
                              :name => gallery.name, 
                              :icon => gallery.icon}
        json
      end
      
      media_json = medias.inject(Hash.new) do |json, media|
        if media.original?
          json["medias"] = [] unless json.key?("medias")
          json["medias"] << {:title => media.title, 
                             :url => media.url, 
                             :icon => media.icon, 
                             :mime => media.mime}
        end
        json
      end
      
      JSON.pretty_generate(galleries_json.merge media_json)
    end
  
end
