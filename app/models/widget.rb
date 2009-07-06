class MediaRocket::WidgetOption
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String
  property :content, String

end

class MediaRocket::GalleryBuilder
  include DataMapper::Resource
  
  property :id, Serial
  property :widget_connector_id, Integer
  
  has n, :options, :class_name => ::MediaRocket::WidgetOption
  
  def admin(options = {})
    options.each do |option|
      
      if current_option = self.options.first(:name => option.name)
        current_option.update_attributes :content => option.content
      else
        new_option = self.options.build(option)
        new_option.save
      end
      
    end
  end
  
  def front(options = {})
    self.content
  end

end

class MediaRocket::MediaList
  include DataMapper::Resource
  
  property :id, Serial
  property :widget_connector_id, Integer
  
  has n, :options, :class_name => ::MediaRocket::WidgetOption
  
  def admin(options = {})
    options.each do |option|
      
      if current_option = self.options.first(:name => option.name)
        current_option.update_attributes :content => option.content
      else
        new_option = self.options.build(option)
        new_option.save
      end
      
    end
  end
  
  def front(options = {})
    self.content
  end

end