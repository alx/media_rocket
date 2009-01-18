module MediaRocket
  module Helpers
    module Content
      
      def media_list_last(options = {}, &block)
        medias = ""
        limit = options[:limit] || 10
        MediaRocket::MediaFile.all(:dimension => nil, :order => [:created_at.desc])[0...limit].each do |media|
          medias << tag(:a, self_closing_tag(:img, :src => media.url, :width => options[:width]), :href => media.url)
        end
        medias
      end
      
      def media_tag_cloud(options = {}, &block)
        
        classes = options[:classes] || %w(nube1 nube2 nube3 nube4 nube5)
        max, min = 0, 0
        output = ""
        
        #
        # Buid sql query, using options[:tags] for selection
        # use Struct because tag object doesn't exist
        #
        query = "SELECT id, name, count(*) as count FROM tags "
        if options[:tags]
          query << "WHERE name IN ( "
          options[:tags].each {|tag| query << "''#{tag}"}
        end
        tags = repository(:default).adapter.query(query)
        
        # tags.each { |t|
        #   max = t.count.to_i if t.count.to_i > max
        #   min = t.count.to_i if t.count.to_i < min
        # }
        # 
        # divisor = ((max - min) / classes.size) + 1

        tags.each { |t|
          puts t.name
          output << tag(:span, t.name)
          #, :class => classes[(t.count.to_i - min) / divisor]
        }
        
        output
      end
      
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

        output = ""

        # display each gallery with its media content
        site.categories.each do |category|

          output << build_category_tree(category)

        end # site.categories

        tag(:table, output, :id => "organize")

      end # media_gallery_organize
      
      def build_category_tree(category, child_of = nil)
        
        output = tag(:tr, tag(:td, category.name), { :id => "category-#{category.id}", :class => "category #{child_of}"})
        
        child_of = "child-of-category-#{category.id}"
        
        category.children.each do |child|
          output << build_category_tree(child, child_of)
        end
        
        category.medias.select{|media| media.original?}.sort{|x,y| x.position <=> y.position }.each do |media|
            output << tag(:tr, tag(:td, media.title), { :id => "media-#{media.id}", :class => "media child-of-category-#{category.id}"})
        end
        
        return output
      end

      def build_thumbnail(media)
        thumbnail = self_closing_tag(:img, :src => media.thumbnail.url)
        tag(:div, thumbnail, :class => "span-4")
      end

      def build_info_box(media)
        tag(:div, media_edit_info(media), :class => "span-5")
      end
      
      def build_media_action_box(media)
        #action = tag(:a, "Move", :href => "/")
        action = link_to "Delete",
                         url(:delete_media_rocket_media, :id => media.id),
                         :rel => "#media_#{media.id}",
                         :class => "remote"
        tag(:div, action, :class => "span-3 prepend-1 last")
      end
      
      def build_category_action_box(category)
        tag(:div, media_add_category(category))
      end
      
      def link_to_remote(text, url, options = {})
        if options.key?(:update)
          options[:rel] = options.delete(:update)
        end
        
        options[:class] = options[:class].to_s.split(" ").push("remote").join(" ")
        
        link_to(text, url, options)
      end
    end
  end
end