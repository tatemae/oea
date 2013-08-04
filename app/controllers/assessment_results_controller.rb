class AssessmentResultsController < ApplicationController
  def index
    @assessment = Assessment.find(params[:id])
  end
end
