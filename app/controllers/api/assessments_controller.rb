class Api::AssessmentsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :skip_trackable
  before_filter :authenticate_user!, only: [:create]
  respond_to :xml, :json

  def index
    page = (params[:page] || 1).to_i
    per_page = 10
    assessments = Assessment.where("assessments.xml LIKE ?", "%#{params[:q]}%").paginate(:page => page, :per_page => per_page)
    respond_with(assessments, :only => [:id, :title, :description])
  end

  def show
    assessment = Assessment.find(params[:id])
    respond_to do |format|
      format.json { render :json => assessment }
      format.xml { render :text => assessment.assessment_xmls.by_newest.first.xml }
    end
  end

  def create
    assessment_xml = request.body.read
    ident = AssessmentParser.parse(assessment_xml).first.ident
    unless assessment = Assessment.find_by(identifier: ident)
      assessment = Assessment.new
      assessment.from_xml(assessment_xml)
    end
    respond_with(assessment, location: nil)
  end

end
