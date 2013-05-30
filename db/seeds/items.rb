class Items
  def self.add_all
    xml_file = File.open("db/seeds/items.xml", "rb")
    updates, creates = Item.load_qti(xml_file)
    updates.each {|u| puts "Updated item #{u.title} - #{u.identifier}" }
    creates.each {|u| puts "Created item #{u.title} - #{u.identifier}" }
  end
end