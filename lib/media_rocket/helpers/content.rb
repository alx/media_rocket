module MediaRocket
  module Helpers
    module Content
      
      def media_gallery_organize(options = {}, &block)

        # <table id="organize">
        #   <tr id="node-1">
        #     <td>Parent</td>
        #   </tr>
        #   <tr id="node-2" class="child-of-node-1">
        #     <td>Child</td>
        #   </tr>
        #   <tr id="node-3" class="child-of-node-2">
        #     <td>Child</td>
        #   </tr>
        # </table>
        
        site = options[:site] || MediaRocket::Site.first
        
        return "" if site.nil?

        # display each gallery with its media content
        output = ""
        site.galleries.roots.each do |gallery|

          output << build_gallery_tree(gallery)

        end # site.galleries
        
        body = tag(:tbody, output)

        tag :table, {:id => "organize", :class => "treeTable"} do
          tag(:thead,
            tag :tr do
              tag(:th, "Name") <<
              tag(:th, "Action", {:class => "action"})
            end
          ) << 
          tag(:tbody, output)
        end

      end # media_gallery_organize
      
      def build_gallery_tree(gallery, child_of = nil)
        
        gallery_id = "gallery-#{gallery.id}"
        
        gallery_urls = self_closing_tag(:a, :rel => url(:edit_media_rocket_gallery, :id => gallery.id), :class => "edit")
        gallery_name = tag(:td, tag(:span, gallery.name + gallery_urls, :class => "gallery"))
        
        gallery_action = tag :td, :class => "action" do 
            gallery_action_add(gallery) <<
            gallery_action_edit(gallery) <<
            gallery_action_delete(gallery)
          end
        
        output = tag(:tr, gallery_name + gallery_action, { :id => gallery_id, :class => "#{child_of}"})
        
        child_of = "child-of-#{gallery_id}"
        
        gallery.medias.select{|media| media.original?}.sort{|x,y| x.position <=> y.position }.each do |media|
          
            media_id = "media-#{media.id}"
            media_title = media.title
            media_title = media_id if media_title.empty?
          
            media_urls = self_closing_tag(:a, :rel => url(:edit_media_rocket_media, :id => media.id), :class => "edit")
            media_urls << self_closing_tag(:a, :rel => url(:media_rocket_media, :id => media.id), :class => "show")
            media_name = tag(:td, tag(:span, media_title + media_urls, :class => "media"))
            
            media_action = tag :td, :class => "action" do 
              media_action_edit(media) <<
              media_action_delete(media)
            end
              
          
            output << tag(:tr, media_name + media_action, { :id => media_id, :class => child_of})
            
            # Add media viewer
            # viewer_content = tag(:td, "Chargement...", { :id => "viewer-#{media_id}", :class => "viewer", :colspan => 2})
            # output << tag(:tr, viewer_content, :class => "child-of-#{media_id}")
        end

        gallery.children.each do |child|
          output << build_gallery_tree(child, child_of)
        end
        
        return output
      end

      def gallery_action_delete(gallery)
        link_to self_closing_tag(:img, :src => media_rocket_image_path("/icons/delete.png"),
                                 :title => "Delete #{gallery.name}", :class => "icon"),
                url(:delete_media_rocket_gallery, :id => gallery.id),
                :rel => "#gallery-#{gallery.id}",
                :class => "remote delete"
      end
      
      
      def gallery_action_add(gallery)
        form :action => url(:new_media_rocket_gallery), :method => "GET",
             :class => "add-gallery", :rel => "#gallery-#{gallery.id}" do
               
          text_field(:name => "name", :value => "Ajouter sous-categorie", :class => "gallery_add") <<
          hidden_field(:name => "parent_id", :value => gallery.id) <<
          self_closing_tag(:input, :src => media_rocket_image_path("/icons/add.png"), 
                           :alt => "Ajouter sous-categorie", :type => "image", :class => "icon")
        end
      end
      
      
      def gallery_action_edit(gallery)
        link_to self_closing_tag(:img, :src => media_rocket_image_path("/icons/folder_edit.png"),
                                 :title => "Edit #{gallery.name}", :class => :icon),
                url(:edit_media_rocket_gallery, :id => gallery.id) << "?height=350&width=350",
                :title => "Edit #{gallery.name}",
                :class => :thickbox
      end
      
      def media_action_delete(media)
        link_to self_closing_tag(:img, :src => media_rocket_image_path("/icons/delete.png"), 
                                 :title => "Delete #{media.title}", :class => "icon"),
                url(:delete_media_rocket_media, :id => media.id),
                :rel => "#media-#{media.id}",
                :class => "remote delete"
      end
      
      def media_action_edit(media)
        link_to self_closing_tag(:img, :src => media_rocket_image_path("/icons/image_edit.png"), 
                                 :title => "Edit #{media.title}", :class => :icon),
                url(:edit_media_rocket_media, :id => media.id) << "?height=200&width=500",
                :title => "Edit #{media.title}",
                :class => :thickbox
      end
    end
  end
end