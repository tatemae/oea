class Assessment < ActiveRecord::Base
  validates_presence_of :title

  has_many :sections, dependent: :destroy
  has_many :items, through: :sections
  has_many :assessment_results, dependent: :destroy
  belongs_to :user
  has_one :assessment_xml

  before_validation(on: :create) do
    @parsed_xml ||= AssessmentParser.parse(self.xml).first if self.xml
    self.title = @parsed_xml.title if @parsed_xml
    self.description = 'Assessment'
  end

  after_initialize :munge_xml

  def munge_xml
    @parsed_xml ||= AssessmentParser.parse(self.xml).first if self.xml
  end

  before_create :create_subitems

  def create_subitems
    self.identifier = @parsed_xml.ident
    self.sections << @parsed_xml.sections.collect{ |section| Section.new(xml: section) }
  end

end
