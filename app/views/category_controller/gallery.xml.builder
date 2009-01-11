xml.gallery do
	xml.name(@category.name)
	for media in @medias do
		xml.image do
			xml.name(media.title)
			xml.description(media.description)
			xml.tags(media.tag_list)
			xml.url(media.url)
		end
	end
end