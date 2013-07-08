class ItemResultsController < ApplicationController
  def index
    @item = Item.find(params[:id])
    respond_to do |format|
      format.html {
        @item
        @summary = params[:type] == 'summary'
      }
      format.json {
        if params[:type] == 'summary'
          render json: @item.results_summary
        else
          render json: @item.item_results
        end
      }
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
