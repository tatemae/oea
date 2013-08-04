class Assessment < ActiveRecord::Base
  validates_presence_of :title

  has_many :sections, dependent: :destroy
  has_many :items, through: :sections
  has_many :assessment_results, dependent: :destroy
  belongs_to :user
  has_many :assessment_xmls, dependent: :destroy

  validates_uniqueness_of :identifier

  def self.from_xml(input_xml, user, src_url=nil)
    xml = AssessmentParser.parse(input_xml).first
    assessment = Assessment.find_by(identifier: xml.ident) || user.assessments.build
    assessment.identifier = xml.ident
    assessment.title = xml.title
    assessment.description = 'Assessment'
    assessment.src_url = src_url
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

  def raw_results( scope_url = nil )
    results = scope_url ? assessment_results.where("referer LIKE ?", "%#{scope_url}%") : assessment_results
  end

  def results_summary( scope_url = nil )
    @results_summary ||= begin
      users = []
      referers = []

      results = raw_results( scope_url )

      results.map do |assessment_result|
        users << assessment_result.user if !users.include?(assessment_result.user)
        referers << assessment_result.referer if !assessment_result.referer.nil? && !referers.include?(item_result.referer)
      end

      submitted = results.by_status_final.load

      {
        renders: users.count,
        submitted: submitted,
        users: users,
        referers: referers,
      }
    end
  end



end