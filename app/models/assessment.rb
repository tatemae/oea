class Assessment < ActiveRecord::Base
  validates_presence_of :title

  has_many :sections

  after_initialize :munge_xml

  def munge_xml
    @parsed_xml ||= AssessmentParser.parse(self.xml).first
    self.identifier = @parsed_xml.ident
    self.sections << @parsed_xml.sections.collect{ |section| Section.new(xml: section) }
  end

  delegate :title, to: :@parsed_xml
end

class AssessmentParser
  include HappyMapper

  tag 'assessment'

  attribute :ident, String
  attribute :title, String
  has_many :sections, self, tag: 'section', parser: :identity, raw: true

  def self.identity arg
    arg
  end
end
