class AssessmentsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :skip_trackable
  before_filter :authenticate_user!, only: [:create, :destroy]
  respond_to :html

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
    end
  end

  def new
  end

  def create
    assessment_xml = params[:assessment][:xml_file].read
    @assessment = Assessment.from_xml(assessment_xml, current_user)
    respond_with(@assessment)
  end

  def destroy
    @assessment = Assessment.find(params[:id])
    @assessment.destroy
    respond_to do |format|
      format.html { redirect_to(assessments_url) }
    end
  end

end
