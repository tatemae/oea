class AssessmentResultsController < ApplicationController
  def index
    @assessment = Assessment.includes(items: :item_results).find(params[:id])
    @results = @assessment.items.collect(&:item_results).flatten
    respond_to do |format|
      format.html do
        @displayed = @results.select{|i| i.session_status == 'initial' }.count #uniq for user?
        @unique_users_count = @results.uniq(&:user_id).count
        @submissions_count = @results.select{|i| i.session_status == 'final' }.count
        results_summaries = @assessment.items.collect(&:results_summary)
        percent_correct_array = results_summaries.collect{ |h| h[:percent_correct] }
        @percent_correct = percent_correct_array.inject(:+).to_f / percent_correct_array.size * 100 #reject zeros?

        avg_time_to_complete_arr = @results.group_by(&:user_id).collect do |k,v|
          sorted = v.sort_by(&:created_at)
          diff = sorted.last.created_at.to_i - sorted.first.created_at.to_i
        end
        @avg_time_to_complete = 0 if avg_time_to_complete_arr.size == 0
        @avg_time_to_complete ||= (avg_time_to_complete_arr.inject(:+).to_f / avg_time_to_complete_arr.size) * 100
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
