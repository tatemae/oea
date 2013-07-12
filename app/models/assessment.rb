class Assessment < ActiveRecord::Base
  validates_presence_of :title

  has_many :sections, dependent: :destroy
  has_many :items, through: :sections
  has_many :assessment_results, dependent: :destroy
  belongs_to :user
  has_many :assessment_xmls

  validates_uniqueness_of :identifier

  def self.from_xml(input_xml, user)
    xml = AssessmentParser.parse(input_xml).first
    assessment = Assessment.find_by(identifier: xml.ident) || user.assessments.build
    assessment.identifier = xml.ident
    assessment.title = xml.title
    assessment.description = 'Assessment'
    assessment.save!
    assessment.assessment_xmls.create!(:xml => input_xml)
    assessment.create_subitems(xml)
    assessment
  end

  def create_subitems(xml)
    xml.sections.collect do |section_xml|
      Section.from_xml(section_xml, self)
    end
  end

end