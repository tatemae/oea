class Assessment < ActiveRecord::Base
  validates_presence_of :title

  has_many :sections
  has_many :assessment_results

  after_initialize :munge_xml

  def munge_xml
    @parsed_xml ||= AssessmentParser.parse(self.xml).first
    self.identifier = @parsed_xml.ident
    self.sections << @parsed_xml.sections.collect{ |section| Section.new(xml: section) }
  end

  delegate :title, to: :@parsed_xml
end
