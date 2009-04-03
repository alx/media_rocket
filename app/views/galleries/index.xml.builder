xml.rocket do
  for gallery in @galleries
    if gallery.is_public?
      xml.gallery do
        xml.id(gallery.id)
        xml.name(gallery.name)
      end
    end
  end
end