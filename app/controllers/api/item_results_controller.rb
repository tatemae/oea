class Api::ItemResultsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :xml, :json

  def index
    scope_url = params[:url] if params[:scope] == 'domain' || params[:scope] == 'page'
    scope_url = get_domain(scope_url) if params[:scope] == 'domain'
    if params[:type] == 'summary'
      results = Item.find(params[:id]).results_summary( scope_url )
    else
      results = Item.find(params[:id]).item_results.where("referer LIKE ?", "%#{scope_url}%")
    end
    respond_to do |format|
      format.json { render json: results }
      format.csv { render text: results.to_csv }
    end
  end
end
