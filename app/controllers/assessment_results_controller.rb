class AssessmentResultsController < ApplicationController
  def show
    @assessment = Assessment.includes(items: :item_results).find(params[:id])
    @results = @assessment.items.collect(&:item_results).flatten
    respond_to do |format|
      format.html do
        @displayed = @results.select{|i| i.session_status == 'initial' }.count #uniq for user?
        @unique_users_count = @results.uniq(&:user_id).count
        @submissions_count = @results.select{|i| i.session_status == 'final' }.count
        results_summaries = @assessment.items.collect(&:results_summary)
        percent_correct_array = results_summaries.collect{ |h| h[:percent_correct] }
        @percent_correct = signif(percent_correct_array.inject(:+).to_f / percent_correct_array.size * 100, 2) #reject zeros?

        assessment_results = @assessment.assessment_results.pluck(:id)
        @avg_time_to_complete = ItemResult.where(:assessment_result_id => assessment_results).average(:time_elapsed) || 0
        @avg_confidence = ItemResult.where(:assessment_result_id => assessment_results).average(:confidence_level) || 'none'
      end
      format.csv do
        send_data(
          @assessment.results_csv,
          :type => "text/csv",
          :filename =>  "results_#{@assessment.title}.csv",
          :disposition => "attachment"
        )
      end
    end
  end

end
