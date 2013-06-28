class Section < ActiveRecord::Base
  after_initialize :munge_xml

  def munge_xml
    @parsed_xml ||= SectionParser.parse(self.xml)
    self.identifier = @parsed_xml.ident
    self.items << @parsed_xml.items.collect{ |item| Item.new(xml: item) }
  end

  has_many :items

  belongs_to :assessment

  delegate :title, to: :@parsed_xml
end
