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

class SectionParser
  include HappyMapper

  tag 'section'
  attribute :ident, String
  attribute :title, String

  has_many :items, self, tag: 'item', parser: :identity, raw: true

  def self.identity arg
    arg
  end
end
