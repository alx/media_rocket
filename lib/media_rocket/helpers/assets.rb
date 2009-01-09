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
      
      def media_rocket_upload_path(*segments)
        media_rocket_public_path_for(:upload, *segments)
      end

      def media_rocket_public_path_for(type, *segments)
        ::MediaTocket.public_path_for(type, *segments)
      end
    end
  end
end