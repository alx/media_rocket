module MediaRocket
  module Helpers
    module Form
      
      def media_upload_form(options = {}, &block)
        
        form :action => url(:upload) do
          form_content = ""
          
          #
          # You can disallow tag text_field by setting options[:title_enabled] to 0
          #
          if (options[:title_enabled].nil? or options[:title_enabled] != 0)
            content = options[:title_label] || "Title"
            
            title_content = tag(:label, content, {:for => content})
            title_content << tag(:br)
            title_content << text_field(:name => "title", :id => content)
            
            form_content << tag(:p, title_content)
          end
          
          
          #
          # You can disallow tag text_field by setting options[:description_enabled] to 0
          #
          if (options[:description_enabled].nil? or options[:description_enabled] != 0)
            content = options[:description_label] || "Description"
            
            description_content = tag(:label, content, {:for => content})
            description_content << tag(:br)
            description_content << text_area(:name => "description", :id => content)
            
            form_content << tag(:p, description_content)
          end
          
          #
          # You can disallow tag text_field by setting options[:tags_enabled] to 0
          #
          if (options[:tags_enabled].nil? or options[:tags_enabled] != 0)
            content = options[:tags_label] || "Tags"
            
            tag_content = tag(:label, content, {:for => content})
            tag_content << tag(:br)
            tag_content << text_field(:name => "tags", :id => content)
            
            form_content << tag(:p, tag_content)
          end
          
          #
          # Delimiter is set by default, you have to set options[:delimiter_enabled]
          # to allow user to set it
          #
          if options[:delimiter_enabled] == 1
            content = options[:delimiter_label] || "Delimiter"
            
            delimiter_content = tag(:label, content, {:for => content})
            delimiter_content << tag(:br)
            delimiter_content << text_field(:name => "delimiter", :id => content)
            
            form_content << tag(:p, delimiter_content)
          end
          
          
          #
          # Build file box
          #
          content = options[:file_label] || "File"
          
          file_content = tag(:label, content, {:for => "media_file"})
          file_content << tag(:br)
          file_content << file_field(:name => "file", :id => "media_file")
          
          form_content << tag(:p, file_content)
          
          #
          # Build submit button
          #
          form_content << tag(:p, submit(options[:submit_label] || "Upload", :id => "media_button"))
          
          # Display form content
          form_content
        end
      end
      
    end
  end
end