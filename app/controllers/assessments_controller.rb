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
    @embedded = params[:src_url].present? || params[:embed].present?

    if params[:id].present? && params[:id] != 'load'
      @assessment = Assessment.find(params[:id])
      if @embedded
        # Just show the assessment. This is here to support old style embed with id=# and embed=true
        @src_url = embed_url(@assessment)
      else
        # Show the full page with analtyics and embed code buttons
        @embed_code = embed_code(@assessment)
      end
    else
      # Get the remote url where we can download the qti
      @src_url = ensure_scheme(params[:src_url]) if params[:src_url].present?
    end

    respond_to do |format|
      format.html { render :layout => @embedded ? 'bare' : 'application' }
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
