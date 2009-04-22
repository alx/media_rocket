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
    end
  end
end