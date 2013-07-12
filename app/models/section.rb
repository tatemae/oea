class Section < ActiveRecord::Base

  has_many :items, dependent: :destroy
  belongs_to :assessment

  def self.from_xml(input_xml, assessment)
    xml = SectionParser.parse(input_xml)
    section = assessment.sections.build
    section.identifier = xml.ident
    section.save!
    section.create_subitems(xml)
    section
  end

  def create_subitems(xml)
    xml.items.each do |item_xml|
      Item.from_xml(item_xml, self)
    end
  end

end