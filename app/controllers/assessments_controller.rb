class AssessmentsController < ApplicationController
  def index
    @assessments = Assessment.all
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
      format.html { render :layout => 'bare' }
    end
  end

  def create
    assessment_xml = request.body.read
    ident = AssessmentParser.parse(assessment_xml).first.ident
    unless assessment = Assessment.find_by(identifier: ident)
      assessment = Assessment.new(xml: assessment_xml)
      assessment.save!
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
