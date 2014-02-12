class AssessmentsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :skip_trackable
  before_filter :authenticate_user!, only: [:new, :create, :destroy]
  load_and_authorize_resource except: [:index, :show, :create]

  respond_to :html

  def index
    if params[:user_id].present?
      @assessments = User.find(params[:user_id]).assessments
    else
      @assessments = Assessment.all
    end
  end

  def show
    @user_id = params[:uid] || user_signed_in? ? current_user.id : ''

    if params[:id].present? && params[:id] != 'load'
      @assessment = Assessment.find(params[:id])
      @embed_code = embed_code(@assessment)
    end

    @src_url = ensure_scheme(params[:src_url]) if params[:src_url].present?

    respond_to do |format|
      format.html { render :layout => params[:src_url].present? ? 'bare' : 'application' }
    end
  end

  def new
  end

  def create
    xml = assessment_params[:xml_file].read
    assessment = Assessment.from_xml(xml, current_user)
    assessment.title = assessment_params[:title] if assessment_params[:title].present?
    assessment.description = assessment_params[:description] if assessment_params[:description].present?
    assessment.save
    respond_with(assessment)
  end

  def destroy
    @assessment.destroy
    respond_to do |format|
      format.html { redirect_to(user_assessments_url(current_user)) }
    end
  end

  private

    def assessment_params
      params.require(:assessment).permit(:title, :description, :xml_file)
    end

end
