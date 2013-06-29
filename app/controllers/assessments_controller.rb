class AssessmentsController < ApplicationController
  def index
    @assessments = Assessment.all
  end

  def show
    if !@assessment = Assessment.find(params[:id])
      redirect_to assessments_path
    end
    respond_to do |format|
      format.html { render :layout => 'bare' }
    end
  end
end
