module MediaRocket
  module Helpers
    module Form
      
      def media_upload_form(options = {}, &block)
        
        case options[:format]
          when "flat" then return media_upload_form_flat(options)
          when "full" then return media_upload_form_full(options)
        end
        
        form :action => slice_url(:upload) do
          form_content = ""
          
          #
          # You can disallow tag text_field by setting options[:title_enabled] to 0
          #
          form_content << media_title_field(options) if (options[:title_enabled].nil? or options[:title_enabled] != 0)          
          
          #
          # You can disallow tag text_field by setting options[:description_enabled] to 0
          #            
          form_content << media_description_field(options) if (options[:description_enabled].nil? or options[:description_enabled] != 0)
          
          #
          # You can disallow tag text_field by setting options[:tags_enabled] to 0
          #
          form_content << media_tag_field(options) if (options[:tags_enabled].nil? or options[:tags_enabled] != 0)
          
          #
          # Delimiter is not set by default, you have to set options[:delimiter_enabled]
          # to allow user to set it
          #
          form_content << media_delimiter_field(options) if options[:delimiter_enabled] == 1
          
          #
          # Site is not set by default, you have to set options[:site_enabled]
          # to allow user to set it
          #
          form_content << media_site_select(options) if options[:site_enabled] == 1
          
          #
          # Category is not set by default, you have to set options[:category_enabled]
          # to allow user to set it
          #
          form_content << media_category_select(options) if options[:category_enabled] == 1
          
          
          #
          # Build file box
          #
          form_content << media_file_field(options)
          
          #
          # Build submit button
          #
          form_content << tag(:p, submit(options[:submit_label] || "Upload", :id => "media_button"))
          
          # Display form content
          form_content
        end
      end
      
      def media_upload_form_flat(options = {}, &block)
        form :action => slice_url(:upload) do
          media_file_field(options) + tag(:p, submit(options[:submit_label] || "Upload", :id => "media_button"))
        end
      end
      
      def media_upload_form_full(options = {}, &block)
        form :action => slice_url(:upload) do
          form_content = media_title_field(options)
          form_content << media_description_field(options)
          form_content << media_tag_field(options)
          form_content << media_delimiter_field(options)
          form_content << media_site_new_field(options)
          form_content << media_site_select(options)
          form_content << media_category_new_field(options)
          form_content << media_category_select(options)
          form_content << media_file_field(options)
          form_content << tag(:p, submit(options[:submit_label] || "Upload", :id => "media_button"))
          form_content
        end
      end
      
      def media_title_field(options = {}, &block)
        content = options[:title_label] || "Title"
        
        title_content = tag(:label, content, {:for => content})
        title_content << tag(:br)
        title_content << text_field(:name => "title", :id => content)
        
        tag(:p, title_content)
      end
      
      def media_description_field(options = {}, &block)
        content = options[:description_label] || "Description"
        
        description_content = tag(:label, content, {:for => content})
        description_content << tag(:br)
        description_content << text_area(:name => "description", :id => content)
        
        tag(:p, description_content)
      end
      
      def media_tag_field(options = {}, &block)
        content = options[:tags_label] || "Tags"
        
        tag_content = tag(:label, content, {:for => content})
        tag_content << tag(:br)
        tag_content << text_field(:name => "tags", :id => content)
          
        tag(:p, tag_content)
      end
      
      def media_delimiter_field(options = {}, &block)
        content = options[:delimiter_label] || "Tag Delimiter"
        
        delimiter_content = tag(:label, content, {:for => content})
        delimiter_content << tag(:br)
        delimiter_content << text_field(:name => "delimiter", :id => content)
        
        tag(:p, delimiter_content)
      end

      def media_site_select(options = {}, &block)
        sites = MediaRocket::Site.all
        
        if sites.empty?
          return ""
        else
          content = options[:site_label] || "Site"
        
          site_content = tag(:label, content, :for => content)
          site_content << tag(:br)
        
        
          choices = ""
          sites.each do |site|
            choices << tag(:option, site.name, :value => site.name)
          end
        
          site_content << tag(:select, choices, {:name => "site", :size => sites.size})
        
          tag(:p, site_content)
        end
      end
      
      def media_site_new_field(options = {}, &block)
        content = options[:site_new_label] || "New Site"
        
        site_content = tag(:label, content, {:for => content})
        site_content << tag(:br)
        site_content << text_field(:name => "new_site", :id => content)
          
        tag(:p, site_content)
      end
            
      def media_category_checkboxes(options = {}, &block)
        categories = MediaRocket::Gallery.all
        
        if categories.empty?
          return ""
        else
          content = options[:category_label] || "Category"
        
          category_content = tag(:label, content, {:for => content})
          category_content << tag(:br)
        
          categories.each do |category|
            category_content << tag(:input, category.name, {:type => "checkbox", :name => "category", :value => category.name})
            category_content << tag(:br)
          end
        
          tag(:p, category_content)
        end
      end
      
      def media_category_select(options = {}, &block)
        categories = MediaRocket::Gallery.all
        
        if categories.empty?
          return ""
        else
          content = options[:category_label] || "Category"
        
          category_content = tag(:label, content, {:for => content})
          category_content << tag(:br)
        
          choices = ""
          level = 1
          categories.select{|cat| cat.parent.nil?}.each do |category|
            choices << media_category_children_option(category)
          end
          
          category_content << tag(:select, choices, {:name => "category", :size => categories.size})
          
          tag(:p, category_content)
        end
      end
      
      def media_category_children_option(category, level = 0)
        
        branch = ""
        branch = ("&nbsp;&nbsp;" * level) + "+-&nbsp;" if level > 0
        
        content = tag(:option, branch + category.name, {:value => category.name})
        category.children.each do |child|
          content << media_category_children_option(child, level + 1)
        end
        content
      end
      
      def media_category_new_field(options = {}, &block)
        content = options[:category_new_label] || "New Category"
        
        category_content = tag(:label, content, {:for => content})
        category_content << tag(:br)
        category_content << text_field(:name => "new_category", :id => content)
          
        tag(:p, category_content)
      end
      
      def media_add_category(category, options = {}, &block)
        field_label = options[:field_label] || ""
        submit_label = options[:submit_label] || "Ajouter Sous-Cat&eacute;gorie &rarr;"
        
        form :action => url(:new_media_rocket_category), :method => "GET", :class => "add-category"  do
          category_content = text_field(:name => "name", :value => field_label)
          category_content << hidden_field(:name => "parent_id", :value => category.id)
          category_content << submit(submit_label)
        end
      end
      
      def media_file_field(options = {}, &block)
        content = options[:file_label] || "File"
        
        file_content = tag(:label, content, {:for => "media_file"})
        file_content << tag(:br)
        file_content << file_field(:name => "file", :id => "media_file")
        
        tag(:p, file_content)
      end
      
      def media_validate_file

        javascript = <<-END_OF_JS
        function checkAttach() {
                if ( document.forms.media_upload.file.value != "" ) {
                  var reg_1 = new RegExp('^.+\.(jpg|jpeg|png|gif|bmp|tif|tiff|ai|pdf)$','i');
                  if ( reg_1.test(document.forms['media_upload'].file.value) ) {
                    return null;
                  } else {
                    return "Format d\'image non supporte";
                  }
                } else {
                    return "Vous devez joindre un fichier";
                }
            }
        END_OF_JS

        rules = ["file|custom|checkAttach()"]

        javascript << "var rules=new Array();"

        rules.each do |rule|
          javascript << "rules[#{rules.index(rule)}]='#{rule}';"
        end

        tag(:script, javascript)
      end
      
      def media_edit_info(media)
        form :action => url(:edit_media_rocket_media, media.id), :method => "GET", :class => "media-info" do
          info = tag(:label, "Titre:", :for => "title")
          info << text_field(:name => "title", :value => media.title)
          info << self_closing_tag(:br)
          
          info << tag(:label, "Description:", :for => "description")
          info << text_field(:name => "description", :value => media.description)
          info << self_closing_tag(:br)
          
          info << tag(:label, "Position:", :for => "position")
          info << text_field(:name => "position", :value => media.position)
          info << self_closing_tag(:br)
          
          info << submit("Modifier")
        end
      end
    end
  end
end