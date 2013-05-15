class Items
  def self.add_all
    xml_file = File.open("app/assets/items_xml/items1.xml", "rb")
    contents = xml_file.read
    xml = Nokogiri::XML.parse(contents)
    xml.css('item').each do |item_xml|
      external_id = item_xml.xpath('@ident').to_s
      if item = Item.find_by_external_id(external_id)
        item.update_attributes(:xml => item_xml.to_xml)
        puts "Updated item #{external_id}"
      else
        item = Item.new
        item.external_id = item_xml.xpath('@ident').to_s
        item.xml = item_xml.to_xml
        item.save!
        puts "Created item #{external_id}"
      end
    end
  end
end