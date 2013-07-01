class Section < ActiveRecord::Base

  has_many :items
  belongs_to :assessment

  after_initialize :munge_xml

  def munge_xml
    @parsed_xml ||= SectionParser.parse(self.xml)
  end

  before_create :create_subitems

  def create_subitems
    self.identifier = @parsed_xml.ident
    self.items << @parsed_xml.items.collect{ |item| Item.new(xml: item) }
  end

  delegate :title, to: :@parsed_xml
end
