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

    respond_to do |format|
      format.html do
        if @summary = params[:type] == 'summary'
          summaries = ItemResult.results_summary(@item_results)
          @item_results_summary = summaries[:item_summaries][0]
          @avg_time_to_complete = summaries[:time_elapsed]/60
          @avg_confidence = summaries[:confidence_level]
        end
      end
      format.json do
        if params[:type] == 'summary'
          render json: ItemResult.results_summary(@item_results)
        else
          render json: @item_results
        end
      end
      format.csv {
        if params[:type] == 'summary'
          send_data(
            @item.results_summary_csv,
            :type => "text/csv",
            :filename =>  "results_summary_#{@item.title}.csv",
            :disposition => "attachment"
          )
        else
          send_data(
            @item.results_csv,
            :type => "text/csv",
            :filename =>  "results_#{@item.title}.csv",
            :disposition => "attachment"
          )
        end
     }
    end
  end

end


 # def results_summary_csv
 #    rs = self.results_summary
 #    CSV.generate do |csv|
 #      csv << rs.keys
 #      csv << [rs[:renders], rs[:submitted].count, rs[:users].count, rs[:referers].count, rs[:correct].count, rs[:percent_correct] * 100]
 #    end
 #  end

 #  def results_csv
 #    results = self.item_results
 #    CSV.generate do |csv|
 #      csv << results.column_names
 #      results.each do |result|
 #        csv << result.attributes.values_at(*results.column_names)
 #      end
 #    end
 #  end