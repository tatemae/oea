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

    index = @items.index(@item)
    @prev_item = index == 0 ? nil : @items[index-1]
    @next_item = index == @items.count-1 ? nil : @items[index+1]

    respond_to do |format|
      format.html { render :layout => 'bare' }
    end
  end

end
