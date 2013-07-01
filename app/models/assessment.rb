class Assessment < ActiveRecord::Base
  validates_presence_of :title

  has_many :sections
  has_many :items, :through => :sections
  has_many :assessment_results

  before_validation(on: :create) do
    self.title = @parsed_xml.title
    self.description = 'Assessment'
  end

  after_initialize :munge_xml

  def munge_xml
    @parsed_xml ||= AssessmentParser.parse(self.xml).first
  end

  before_create :create_subitems

  def create_subitems
    self.identifier = @parsed_xml.ident
    self.sections << @parsed_xml.sections.collect{ |section| Section.new(xml: section) }
  end

end
