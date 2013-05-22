class Api::ResultsController < ApplicationController
  def index
    #TODO: scope
    if params[:type] == 'summary'
      results = Item.find(params[:item_id]).results_summary
    else
      results = Item.find(params[:item_id]).item_results
    end
    respond_to do |format|
      format.json { render json: results }
      format.csv { render text: results.to_csv }
    end
  end
end
