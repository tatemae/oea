module AssessmentResultsHelper

  def assessment_result_title
    if @assessment
      link_to @assessment.title, assessment_path(@assessment)
    elsif params[:src_url].present?
      link_to params[:src_url], params[:src_url]
    else
      params[:identifier] || params[:eid]
    end
  end

end