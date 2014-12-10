class ItemResultsController < ApplicationController

  def index
    
    @title = [ params[:scope_url],
      params[:identifier],
      params[:eid],
      params[:keyword],
      params[:objective],
      params[:external_user_id],
      params[:src_url]].reject! { |i| i.blank? }.join(' and ')

    @item_results = ItemResult.raw_results(params)

    if @summary = params[:type] == 'summary'
      summaries = ItemResult.results_summary(@item_results)
      @item_results_summary = summaries[:item_summaries][0]
      @avg_time_to_complete = summaries[:time_elapsed]/60
      @avg_confidence = summaries[:confidence_level]
    end

    respond_to do |format|
      format.html do
        render
      end
      format.json do
        if params[:type] == 'summary'
          render json: ItemResult.results_summary(@item_results)
        else
          render json: @item_results
        end
      end
      format.csv {
        filename = @title.gsub(/[^0-9A-Za-z.\-]/, '_').truncate(30)
        if params[:type] == 'summary'
          send_data(
            results_summary_csv,
            :type => "text/csv",
            :filename =>  "results_summary_#{filename}.csv",
            :disposition => "attachment"
          )
        else
          send_data(
            results_csv,
            :type => "text/csv",
            :filename =>  "results_#{filename}.csv",
            :disposition => "attachment"
          )
        end
     }
    end
  end

  private
    def results_summary_csv
      CSV.generate do |csv|
        csv << ["Number of Times Displayed", "Number of Unique Users", "Number of Submissions", "Average Score", "Number of Referers", "Average Time Spent Completing Assessment (seconds)", "Average Confidence"]
        csv << [@item_results_summary[:number_renders], @item_results_summary[:number_of_users], @item_results_summary[:number_submitted], signif(@item_results_summary[:percent_correct], 2) , @item_results_summary[:number_referers], @avg_time_to_complete, @avg_confidence]
      end
    end

    def results_csv
      CSV.generate do |csv|
        csv << ItemResult.column_names
        @item_results.each do |result|
          csv << result.attributes.values_at(*ItemResult.column_names)
        end
      end
    end

end