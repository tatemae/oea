class Api::AssessmentsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :skip_trackable
  before_filter :authenticate_user!, only: [:create]
  respond_to :xml, :json

  def index
    page = (params[:page] || 1).to_i
    per_page = 10
    @assessments = Assessment.where("assessment_xmls.xml LIKE ?", "%#{params[:q]}%").includes(:assessment_xmls).paginate(:page => page, :per_page => per_page)
    respond_to do |format|
      format.json { render :json => @assessments, :only => [:id, :title, :description] }
      format.xml { render }
    end
  end

  def show
    if params[:id]
      assessment = Assessment.find(params[:id])
    elsif params[:ident]
      assessment = Assessment.find_by(identifier: params[:ident])
    end
    respond_to do |format|
      format.json { render :json => assessment }
      format.xml { render :text => assessment.assessment_xmls.by_newest.first.xml }
    end
  end

  def create
    assessment = Assessment.from_xml(request.body.read, current_user)
    respond_with(assessment, location: nil)
  end

end
