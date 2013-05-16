class Items
  def self.add_all
    xml_file = File.open("app/assets/items_xml/items1.xml", "rb")
    contents = xml_file.read
    xml = Nokogiri::XML.parse(contents)
    xml.css('item').each do |item_xml|
      identifier = item_xml.xpath('@ident').to_s
      if item = Item.find_by_identifier(identifier)
        item.update_attributes(:xml => item_xml.to_xml)
        puts "Updated item #{identifier}"
      else
        item = Item.new
        item.identifier = item_xml.xpath('@ident').to_s
        item.xml = item_xml.to_xml
        item.save!
        puts "Created item #{identifier}"
      end
    end
  end
end