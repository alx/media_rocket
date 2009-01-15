xml.gallery do
	xml.name(@category.name)
	for media in @medias do
		xml.image do
			xml.name(media.title)
			xml.description(media.description)
			xml.tags(media.tag_list)
			xml.url(media.url)
		
			if media.files
			  xml.sizes do
			    for file in media.files do
			      xml.size(file.url, :dimension => file.dimension)
		      end # for
		    end # xml.size
	    end # if
    end # xml.image
	end # for
end # xml.gallery