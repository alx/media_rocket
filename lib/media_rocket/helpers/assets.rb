module MediaRocket
  module Helpers
    module Assets
      def media_rocket_image_path(*segments)
        media_rocket_public_path_for(:image, *segments)
      end

      def media_rocket_javascript_path(*segments)
        media_rocket_public_path_for(:javascript, *segments)
      end

      def media_rocket_stylesheet_path(*segments)
        media_rocket_public_path_for(:stylesheet, *segments)
      end
      
      def media_rocket_flash_path(*segments)
        # Use String instead of Symbol
        # if type is not declared in app_dir_for
        media_rocket_public_path_for("flash", *segments)
      end
      
      def media_rocket_upload_path(*segments)
        media_rocket_public_path_for(:upload, *segments)
      end

      def media_rocket_public_path_for(type, *segments)
        ::MediaRocket.public_path_for(type, *segments)
      end
      
      def media_rocket_js
        script = ""
        ['jquery/jquery.js',
         'jquery/jquery.ui.js',
         'jquery/jquery.alerts.js',
         'jquery/jquery.confirm.js',
         'jquery/jquery.form.js',
         'jquery/jquery.validate.js',
         'jquery/jquery.livequery.js',
         'jquery/thickbox.js',
         'jquery/jquery.uploadify.js',
         'jquery/jquery.base64.js',
         'json2.js',
         'permissions.js',
         'master.js'].each do |file|
          script << media_rocket_js_line(file)
        end
        script
      end
      
      def media_rocket_js_line(file)
        "<script src='#{media_rocket_javascript_path file}' type='text/javascript' charset='utf-8'></script>\n"
      end
      
      def media_rocket_css
        css = "<!--[if IE]>#{media_rocket_css_line 'ie.css'}<![endif]-->\n"
      	
        ['jquery-ui-1.7.1.custom.css',
         'jquery.alerts.css',
         'screen.css',
         'master.css'].each do |file|
          css << media_rocket_css_line(file)
        end
        css
      end
      
      def media_rocket_css_line(file)
        "<link rel='stylesheet' href='#{media_rocket_stylesheet_path file}' type='text/css' media='screen, projection'>\n"
      end
    end
  end
end