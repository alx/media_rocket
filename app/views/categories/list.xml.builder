xml.rocket do
  for category in @categories
    xml.category do
      xml.id(category.id)
      xml.name(category.name)
    end
  end
end