class SectionsController < ApplicationController
  def index
    @assessment = Assessment.find(params[:assessment_id])
    @sections = @assessment.sections
  end

  def show
    @section = Section.find(params[:id])
  end
end
