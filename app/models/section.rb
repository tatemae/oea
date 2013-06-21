class Section < ActiveRecord::Base
  after_initialize :munge_xml

  def munge_xml
    @parsed_xml ||= SectionPaser.parse(self.xml)
    self.identifier = @parsed_xml.ident
  end

  belongs_to :assessment

  delegate :title, to: :@parsed_xml
end

class SectionPaser
  include HappyMapper

  tag 'section'
  attribute :ident, String
  attribute :title, String
end
