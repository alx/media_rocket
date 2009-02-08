xml.rocket do
  for gallery in @galleries
    xml.gallery do
      xml.id(gallery.id)
      xml.name(gallery.name)
      xml.url(gallery.url << ".xml")
    end
  end
end