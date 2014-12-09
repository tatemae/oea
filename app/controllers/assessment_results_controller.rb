class AssessmentResultsController < ApplicationController

  def show

    if params[:id].present?
      # The assessment lives in OEA
      @assessment = Assessment.find(params[:id])
      @assessment_results = AssessmentResult.where(assessment_id: @assessment.id) 
    else
      # The assessment does not live in OEA
      @assessment_query = query(:identifier) || query(:eid) || query(:src_url)
      render nothing: true, status: :not_acceptable and return if @assessment_query.blank?
      @assessment_results = AssessmentResult.where(@assessment_query)  
    end

    @item_results = ItemResult.where(assessment_result_id: @assessment_results.map(&:id))

    respond_to do |format|
      format.html do
        @displayed = @assessment_results.length
        @unique_users_count = @assessment_results.uniq.pluck(:user_id).count
        @submissions_count = @item_results.where(session_status: 'final').count
        results_summaries = ItemResult.results_summary(@item_results)
        @percent_correct = signif(results_summaries[:percent_correct] * 100, 2) #reject zeros?
        @avg_time_to_complete = results_summaries[:time_elapsed]/60
        @avg_confidence = results_summaries[:confidence_level]
        @item_summaries = results_summaries[:item_summaries]
      end
      format.csv do
        identifier = @assessment.id.to_s if @assessment.present?
        identifier ||= params[:identifier] || params(:eid) || params(:src_url)
        identifier.gsub!(/[^0-9A-Za-z.\-]/, '_')
        send_data(
          csv_result(@item_results),
          :type => "text/csv",
          :filename => "assessment_results_#{identifier}.csv",
          :disposition => "attachment"
        )
      end
    end
  end

  private

    def query(key)
      {key => params[key]} if params[key].present?
    end

    def csv_result(item_results)
      CSV.generate do |csv|
        csv << ItemResult.column_names
        item_results.each do |result|
          csv << result.attributes.values_at(*ItemResult.column_names)
        end
      end
    end

end
