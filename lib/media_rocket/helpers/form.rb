module MediaRocket
  module Helpers
    module Form
      
      def media_uploadify(options = {}, &block)
        tag(:script, uploadify_script, :type => "text/javascript") <<
        media_gallery_new_field(:gallery_new_class => "uploadify") << 
        media_gallery_select(:gallery_select_class => "uploadify") <<
        self_closing_tag(:input, {:type => :file, :name => :fileInput, :id => :fileInput}) <<
        tag(:a, "Start Upload", :href => "javascript:startUpload('fileInput')") << " | " <<
        tag(:a, "clear Queue", :href => "javascript:$('#fileInput').fileUploadClearQueue()") <<
        tag(:div, "", {:id => "finishedQueue"})
      end
      
      def uploadify_script
        
        session_key     = Merb::Config[:session_id_key]
        uploader_path   = media_rocket_flash_path "uploader.swf"
        cancel_img_path = media_rocket_image_path "cancel.png"
        upload_route    = Merb::Router.url(:media_rocket_upload)
        init_edit_route = Merb::Router.url(:edit_media_rocket_media, :id => 0) << "?height=200&width=500"
        
        # '&gallery_name=' + $('input.uploadify').val() +
        # '&#{session_key} = #{cookies[session_key]}');
        
        "
        function startUpload(id) {
          var data = '&site_id=1&gallery_id='   + $('select.uploadify').val();
          
          if($('input.uploadify').val().length)
            data += '&gallery_name='   + escape($('input.uploadify').val());  
          
          $('#'+id).fileUploadSettings('scriptData', data);
          $('#'+id).fileUploadStart();
          
          // Fix IE Bug: http://www.uploadify.com/forum/viewtopic.php?f=4&t=278
          fileInputUploader = document.getElementById('fileInputUploader');
        }
        $(document).ready(function() {
          $('#fileInput').fileUpload ({
            'uploader'    : '#{uploader_path}',
            'script'      : '#{upload_route}',
            'cancelImg'   : '#{cancel_img_path}',
            'multi'       : true,
            onComplete: function (evt, queueID, fileObj, response, data) {
              json = JSON.parse(response);
              edit_route = '#{init_edit_route}'.replace(/\\/0/, '/' + json.media_id);
                
              $('#finishedQueue').append('#{uploadify_finished_media}');
              item = $('.finishedItem:last');
              item.children('.title').attr('innerHTML', 'Title: ' + json.title);
              item.children('img').attr('src', json.icon);
              item.children('a').attr('href', edit_route);
        		}
          });
        });"
      end
      
      def uploadify_finished_media
        "<div class=\\'finishedItem\\'><img src=\\'\\'/><br><span class=\\'title\\'>Title: </span><br><a class=\\'thickbox\\' href=\\'\\' title=\\'Edit\\'>Edit</a></div>"
      end
      
      def media_upload_form(options = {}, &block)
        
        case options[:format]
          when "flat" then return media_upload_form_flat(options)
          when "full" then return media_upload_form_full(options)
          when "uploadify" then return media_uploadify(options)
        end
        
        form :action => slice_url(:upload), :id => "uploadForm" do
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
          # gallery is not set by default, you have to set options[:gallery_enabled]
          # to allow user to set it
          #
          form_content << media_gallery_select(options) if options[:gallery_enabled] == 1
          
          
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
        form :action => slice_url(:upload), :id => "uploadForm" do
          media_file_field(options) + tag(:p, submit(options[:submit_label] || "Upload", :id => "media_button"))
        end
      end
      
      def media_upload_form_full(options = {}, &block)
        form :action => slice_url(:upload), :id => "uploadForm" do
          form_content = media_title_field(options)
          form_content << media_description_field(options)
          form_content << media_tag_field(options)
          form_content << media_delimiter_field(options)
          form_content << media_site_new_field(options)
          form_content << media_site_select(options)
          form_content << media_gallery_new_field(options)
          form_content << media_gallery_select(options)
          form_content << media_file_field(options)
          form_content << tag(:p, submit(options[:submit_label] || "Upload", :id => "media_button"))
          form_content
        end
      end
      
      def media_title_field(options = {}, &block)
        content = options[:title_label] || "Title"
        
        title_content = tag(:label, content, {:for => "title"})
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
        sites = ::MediaRocket::Site.all
        
        if sites.empty?
          return ""
        else
          content = options[:site_label] || "Site"
        
          site_content = tag(:label, content, :for => content)
          site_content << tag(:br)
        
        
          choices = ""
          sites.each do |site|
            choices << tag(:option, site.name, :value => site.id)
          end
        
          site_content << tag(:select, choices, {:name => "site_id", :size => sites.size})
        
          tag(:p, site_content)
        end
      end
      
      def media_site_new_field(options = {}, &block)
        content = options[:site_new_label] || "New Site"
        
        site_content = tag(:label, content, {:for => content})
        site_content << tag(:br)
        site_content << text_field(:name => "site_name", :id => content)
          
        tag(:p, site_content)
      end
            
      def media_gallery_checkboxes(options = {}, &block)
        galleries = ::MediaRocket::Gallery.all
        
        if galleries.empty?
          return ""
        else
          content = options[:gallery_label] || "Gallery"
        
          gallery_content = tag(:label, content, {:for => content})
          gallery_content << tag(:br)
        
          galleries.each do |gallery|
            gallery_content << tag(:input, gallery.name, {:type => "checkbox", :name => "gallery", :value => gallery.name})
            gallery_content << tag(:br)
          end
        
          tag(:p, gallery_content)
        end
      end
      
      def media_gallery_select(options = {}, &block)
        
        galleries = ::MediaRocket::Gallery.all :site_id => (options[:site_id] || MediaRocket::Site.first.id)
        
        if galleries.nil?
          return ""
        else
          content = options[:gallery_label] || "Gallery"
        
          gallery_content = tag(:label, content, {:for => content})
          gallery_content << tag(:br)
        
          choices = ""
          level = 1
          galleries.select{|cat| cat.parent.nil?}.each do |gallery|
            choices << media_gallery_children_option(gallery)
          end
          
          gallery_content << tag(:select, choices, {:name => "gallery_id",
                                                    :class => options[:gallery_select_class],
                                                    :id => "media_gallery_select"})
          
          tag(:p, gallery_content)
        end
      end
      
      def media_gallery_children_option(gallery, level = 0)
        
        branch = ""
        branch = ("&nbsp;&nbsp;" * level) + "+-&nbsp;" if level > 0
        
        content = tag(:option, branch + gallery.name, {:value => gallery.id})
        gallery.children.each do |child|
          content << media_gallery_children_option(child, level + 1)
        end
        content
      end
      
      def media_gallery_new_field(options = {}, &block)
        content = options[:gallery_new_label] || "New Gallery"
        
        gallery_content = tag(:label, content, {:for => content})
        gallery_content << tag(:br)
        gallery_content << text_field(:name => "gallery_name", 
                                      :id => "media_gallery_input_name", 
                                      :class => options[:gallery_new_class])
          
        tag(:p, gallery_content)
      end
      
      def media_add_gallery(gallery, options = {}, &block)
        field_label = options[:field_label] || ""
        submit_label = options[:submit_label] || "Ajouter Sous-Cat&eacute;gorie &rarr;"
        
        form :action => url(:new_media_rocket_gallery), :method => "GET", :class => "add-gallery"  do
          gallery_content = text_field(:name => "name", :value => field_label)
          gallery_content << hidden_field(:name => "parent_id", :value => gallery.id)
          gallery_content << submit(submit_label)
        end
      end
      
      def media_file_field(options = {}, &block)
        content = options[:file_label] || "File"
        
        file_content = tag(:label, content + tag(:em, '*'), {:for => "media_file"})
        file_content << tag(:br)
        file_content << file_field(:name => "file", :id => "media_file", :class => "required")
        
        tag(:p, file_content)
      end
      
      def media_edit_info(media)
        form :action => url(:edit_media_rocket_media, media.id), :method => "GET", :class => "media-info" do
          info = tag(:label, tag(:span, "Titre:"), :for => "title")
          info << text_field(:name => "title", :value => media.title)
          info << self_closing_tag(:br)
          
          info << tag(:label, tag(:span, "Description:"), :for => "description")
          info << text_field(:name => "description", :value => media.description)
          info << self_closing_tag(:br)
          
          info << tag(:label, tag(:span, "Position:"), :for => "position")
          info << text_field(:name => "position", :value => media.position)
          info << self_closing_tag(:br)
          
          info << submit("Modifier")
        end
      end
    end
  end
end