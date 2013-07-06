class Api::ItemResultsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :xml, :json

  def index
    #TODO: scope
    if params[:type] == 'summary'
      results = Item.find(params[:id]).results_summary
    else
      results = Item.find(params[:id]).item_results
    end
    respond_to do |format|
      format.json { render json: results }
      format.csv { render text: results.to_csv }
    end
  end
end
