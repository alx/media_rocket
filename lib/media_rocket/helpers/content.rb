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
        
        site = options[:site] || MediaRocket::Site.first
        
        return "" if site.nil?

        output = ""

        # display each gallery with its media content
        site.categories.each do |category|
          children = ''

          category.medias.sort{|x,y| x.position <=> y.position }.each do |media|

            # Do not try to display associated file (yet)
            if media.original?
              content = build_thumbnail(media)
              content << build_info_box(media)
              content << build_media_action_box(media)

              children << tag(:div, content, {:id => "media_#{media.id}", :class => 'organize_media span-14 push-1'})
            end
          end # category.medias

          content = tag(:h4, category.name)
          content << link_to( "Delete",
                              url(:delete_media_rocket_category, :id => category.id),
                              :rel => "#category_#{category.id}",
                              :class => "remote")
          content << children
          content << build_category_action_box(category)
          output << tag(:div, content, {:id => "category_#{category.id}", :class => 'organize_category span-15 push-1'})

        end # site.categories

        output

      end # media_gallery_organize

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