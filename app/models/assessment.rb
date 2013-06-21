class Assessment < ActiveRecord::Base
  after_initialize :munge_xml

  def munge_xml
    @parsed_xml ||= AssessmentParser.parse(self.xml).first
    self.identifier = @parsed_xml.ident
  end

  delegate :title, to: :@parsed_xml
end

class AssessmentParser
  include HappyMapper

  tag 'assessment'
  attribute :ident, String
  attribute :title, String
end
