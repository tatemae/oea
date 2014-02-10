class AssessmentsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :skip_trackable
  before_filter :authenticate_user!, only: [:new, :create, :destroy]
  respond_to :html

  def index
    @assessments = Assessment.all
  end

  def show
    @user_id = params[:uid] || user_signed_in? ? current_user.id : ''

    if params[:id].present? && params[:id] != 'load'
      @assessment = Assessment.find(params[:id])
      @embed_code = embed_code(@assessment)
    end

    respond_to do |format|
      format.html { render :layout => params[:src_url].present? ? 'bare' : 'application' }
    end
  end

  def new
  end

  def create
    xml = params[:assessment][:xml_file].read
    assessment = Assessment.from_xml(xml, current_user)

    assessment.title = params[:assessment][:title] if params[:assessment][:title].present?
    assessment.description = params[:assessment][:description] if params[:assessment][:description].present?
    assessment.save

    respond_with(assessment)
  end

  def destroy
    @assessment = Assessment.find(params[:id])
    @assessment.destroy
    respond_to do |format|
      format.html { redirect_to(user_assessments_url(current_user)) }
    end
  end

end
