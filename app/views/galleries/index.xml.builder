xml.rocket do
  for gallery in @galleries
    xml.gallery do
      xml.id(gallery.id)
      xml.name(gallery.name)
    end
  end
end