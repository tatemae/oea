class Section < ActiveRecord::Base

  has_many :items, dependent: :destroy
  belongs_to :assessment

  def from_xml(input_xml)
    xml = SectionParser.parse(input_xml)
    self.identifier = xml.ident
    self.save!
    create_subitems(xml)
  end

  def create_subitems(xml)
    xml.items.each do |item_xml|
      item_xml = ItemParser.parse(item_xml)
      identifier = Item.parse_identifier(item_xml)
      item = Item.where(:identifier => identifier).first
      item = self.items.create! unless item
      item.from_xml(item_xml)
    end
  end

end
