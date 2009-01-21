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

        head = tag(:thead, tag(:tr, tag(:th, "Name") + tag(:th, "Action", {:class => "action"})))

        # display each gallery with its media content
        output = ""
        site.categories.roots.each do |category|

          output << build_category_tree(category)

        end # site.categories
        
        body = tag(:tbody, output)

        tag(:table, head + body, {:id => "organize", :class => "treeTable"})

      end # media_gallery_organize
      
      def build_category_tree(category, child_of = nil)
        
        category_id = "category-#{category.id}"
        
        categorya_urls = self_closing_tag(:a, :rel => url(:edit_media_rocket_category, :id => category.id), :class => "edit")
        category_name = tag(:td, tag(:span, category.name + categorya_urls, :class => "category"))
        category_action = tag(:td, category_action_add(category) + category_action_delete(category), :class => "action")
        
        output = tag(:tr, category_name + category_action, { :id => category_id, :class => "#{child_of}"})
        
        child_of = "child-of-#{category_id}"
        
        category.medias.select{|media| media.original?}.sort{|x,y| x.position <=> y.position }.each do |media|
          
            media_id = "media-#{media.id}"
          
            media_urls = self_closing_tag(:a, :rel => url(:edit_media_rocket_media, :id => media.id), :class => "edit")
            media_urls << self_closing_tag(:a, :rel => url(:media_rocket_media, :id => media.id), :class => "show")
            media_name = tag(:td, tag(:span, (media.title || media_id) + media_urls, :class => "media"))
            media_action = tag(:td, media_action_delete(media), :class => "action")
          
            output << tag(:tr, media_name + media_action, { :id => media_id, :class => child_of})
            
            # Add media viewer
            viewer_content = tag(:td, "Chargement...", { :id => "viewer-#{media_id}", :class => "viewer", :colspan => 2})
            output << tag(:tr, viewer_content, :class => "child-of-#{media_id}")
        end

        category.children.each do |child|
          output << build_category_tree(child, child_of)
        end
        
        return output
      end

      def category_action_delete(category)
        link_to self_closing_tag(:img, :src => media_rocket_image_path("/icons/delete.png"),
                                 :title => "Delete #{category.name}", :class => "icon"),
                url(:delete_media_rocket_category, :id => category.id),
                :rel => "#category-#{category.id}",
                :class => "remote delete"
      end
      
      def category_action_add(category)
        form :action => url(:new_media_rocket_category), :method => "GET",
             :class => "add-category", :rel => "#category-#{category.id}" do
               
          category_content = text_field(:name => "name", :value => "Ajouter sous-categorie", :class => "category_add")
          category_content << hidden_field(:name => "parent_id", :value => category.id)
          
          category_content << self_closing_tag(:input, :src => media_rocket_image_path("/icons/add.png"), 
                                               :alt => "Ajouter sous-categorie", :type => "image", :class => "icon")
        end
      end
      
      def media_action_delete(media)
        link_to self_closing_tag(:img, :src => media_rocket_image_path("/icons/delete.png"), 
                                 :title => "Delete #{media.title}", :class => "icon"),
                url(:delete_media_rocket_media, :id => media.id),
                :rel => "#media-#{media.id}",
                :class => "remote delete"
      end
    end
  end
end