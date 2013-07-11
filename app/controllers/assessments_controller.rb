class AssessmentsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :skip_trackable
  before_filter :authenticate_user!, only: [:create]
  respond_to :html, :xml

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      @assessments = user.assessments
    else
      @assessments = Assessment.all
    end
  end

  def show
    if !@assessment = Assessment.find(params[:id])
      redirect_to assessments_path
    end
    @items = @assessment.items.by_oldest
    if params[:item]
      @item = Item.find(params[:item])
    else
      @item = @items.first
    end

    create_item_result(@item)

    @question_count = @items.count
    @current_index = @items.index(@item)
    @prev_item = @current_index == 0 ? nil : @items[@current_index-1]
    @next_item = @current_index == @question_count-1 ? nil : @items[@current_index+1]

    respond_to do |format|
      format.html { render :layout => params[:embed].present? ? 'bare' : 'application' }
      format.xml { render :text => @assessment.assessment_xml.xml }
    end
  end

  def new
  end

  def create
    assessment_xml = params[:assessment][:xml_file].read
    ident = AssessmentParser.parse(assessment_xml).first.ident
    unless assessment = Assessment.find_by(identifier: ident)
      parsed_xml = AssessmentParser.parse(assessment_xml).first if assessment_xml
      title = parsed_xml.title if parsed_xml
      description = 'Assessment'
      assessment = current_user.assessments.create!(title: title, description: description)
      AssessmentXml.create!(xml: assessment_xml, assessment_id: assessment.id)
      assessment.create_subitems
    end
    respond_with(assessment, location: nil)
  end

  def destroy
    @assessment = Assessment.find(params[:id])
    @assessment.destroy
    respond_to do |format|
      format.html { redirect_to(assessments_url) }
    end
  end

end
