class Assessment < ActiveRecord::Base
  validates_presence_of :title

  has_many :sections, dependent: :destroy
  has_many :items, through: :sections
  has_many :assessment_results, dependent: :destroy
  belongs_to :user
  has_many :assessment_xmls

  def from_xml(input_xml)
    xml = AssessmentParser.parse(input_xml).first
    self.identifier = xml.ident
    self.title = xml.title
    self.description = 'Assessment'
    self.save!
    self.assessment_xmls.create!(:xml => input_xml)
    create_subitems(xml)
  end

  private

    def create_subitems(xml)
      self.sections << xml.sections.collect do |section_xml|
        section = Section.new(:assessment_id => self.id) # TODO make update work
        section.from_xml(section_xml)
        section
      end
    end

end
