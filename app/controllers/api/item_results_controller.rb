class Api::ItemResultsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :skip_trackable
  respond_to :json, :csv, :xml

  def index
    scope_url = params[:url] if params[:scope] == 'domain' || params[:scope] == 'page'
    scope_url = get_domain(scope_url) if params[:scope] == 'domain'
    if params[:type] == 'summary'
      results = Item.find(params[:id]).results_summary( scope_url )
    else
      results = Item.find(params[:id]).raw_results( scope_url )
    end
    respond_to do |format|
      format.json { render json: results }
      format.xml { render xml: results }
      format.csv { render text: results.to_csv }
    end
  end

  def create
    rendered_time, referer, user = tracking_info
    @item_result = user.item_results.create!(
      identifier: params[:identifier],
      item_id: params[:item_id],
      rendered_datestamp: rendered_time,
      referer: referer,
      ip_address: request.ip,
      time_elapsed: params['time_elapsed'],
      confidence_level: convert_confidence_level,
      session_status: params[:session_status] || 'initial')
    respond_with(:api, @item_result)
  end

  private

  def convert_confidence_level
    case params['confidence_level']
      when "Maybe?" then 1
      when "Probably." then 2
      when "Definitely!" then 3
    end
  end

end
