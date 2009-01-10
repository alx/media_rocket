module MediaRocket
  module Helpers
    module Content
      
      def media_list_last(options = {}, &block)
        medias = ""
        limit = options[:limit] || 10
        medias = MediaRocket::Media.all(:order => [:created_at.desc])
        
        medias[0...limit].each do |media|
          medias << tag(:a, self_closing_tag(:img, :src => media.url), :href => media.url)
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
      
    end
  end
end