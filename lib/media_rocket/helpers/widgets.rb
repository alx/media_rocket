module Webbastic
  module Helpers
    module Widgets
      
      class MediaListWidget < Webbastic::Widget
        
        def initialize(options)
          super
          self.name = "Media List"
          self.page_id = options[:page_id]
          super
        end
        
        def widget_headers
          [['gallery_id', 1]]
        end
        
        def widget_content
          gallery_id = self.headers.first(:key => 'gallery_id').value
          gallery = ::MediaRocket::Gallery.first(:id => gallery_id)
          medias = gallery.medias.select{|media| media.original?}
          
          content = "<ul>"
          medias.each do |media|
            content << "<li><a href='#{media.url}'>#{media.url}</a></li>"
          end
          content << "</ul>"
        end
        
      end
      
    end
  end
end