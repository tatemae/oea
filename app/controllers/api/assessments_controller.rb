class Api::AssessmentsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :xml, :json

  def index
    page = (params[:page] || 1).to_i
    per_page = 10
    assessments = Assessment.where("assessments.xml LIKE ?", "%#{params[:q]}%").paginate(:page => page, :per_page => per_page)
    respond_with(assessments, :only => [:id, :title, :description])
  end

  def create
    assessment_xml = request.body.read
    ident = AssessmentParser.parse(assessment_xml).first.ident
    unless assessment = Assessment.find_by_identifier(ident)
      assessment = Assessment.new(xml: assessment_xml)
      assessment.save!
    end
    respond_with(assessment, location: nil)
  end

end
