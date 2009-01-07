class MediaRocket::Tag
  
  def self.parse(list)
    tags = []
    
    return tags if list.blank?
    list = list.dup
    
    # Parse the quoted tags
    list.gsub!(/"(.*?)"\s*,?\s*/) { tags << $1; "" }
    
    # Strip whitespace and remove blank tags
    (tags + list.split(',')).map!(&:strip).delete_if(&:blank?)
  end
  
  # Options:
  #  :start_at - Restrict the tags to those created after a certain time
  #  :end_at - Restrict the tags to those created before a certain time
  #  :conditions - A piece of SQL conditions to add to the query
  #  :limit - The maximum number of tags to return
  #  :order - A piece of SQL to order by. Eg 'tags.count desc' or 'taggings.created_at desc'
  #  :at_least - Exclude tags with a frequency less than the given value
  #  :at_most - Exclude tags with a frequency greater then the given value
  def tag_counts(options = {})
    # options.assert_valid_keys :start_at, :end_at, :conditions, :at_least, :at_most, :order, :limit
    # 
    # scope = scope(:find)
    # start_at = sanitize_sql(['taggings.created_at >= ?', options[:start_at]]) if options[:start_at]
    # end_at = sanitize_sql(['taggings.created_at <= ?', options[:end_at]]) if options[:end_at]
    #   
    # conditions = [
    #   "taggings.taggable_type = '#{name}'",
    #   options[:conditions],
    #   scope && scope[:conditions],
    #   start_at,
    #   end_at
    # ]
    # conditions = conditions.compact.join(' and ')
    #   
    # at_least  = sanitize_sql(['count >= ?', options[:at_least]]) if options[:at_least]
    # at_most   = sanitize_sql(['count <= ?', options[:at_most]]) if options[:at_most]
    # having    = [at_least, at_most].compact.join(' and ')
    # group_by  = 'tags.id, tags.name having count(*) > 0'
    # group_by << " and #{having}" unless having.blank?
    # 
    # Tag.find(:all,
    #   :select     => 'tags.id, tags.name, COUNT(*) AS count', 
    #   :joins      => "LEFT OUTER JOIN taggings ON tags.id = taggings.tag_id LEFT OUTER JOIN #{table_name} ON #{table_name}.#{primary_key} = taggings.taggable_id",
    #   :conditions => conditions,
    #   :group      => group_by,
    #   :order      => options[:order],
    #   :limit      => options[:limit]
    # )
  end
  
  def ==(object)
    super || (object.is_a?(Tag) && name == object.name)
  end
  
  def to_s
    name
  end
  
end
