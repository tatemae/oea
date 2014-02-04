class Api::ItemResultsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :skip_trackable
  respond_to :json

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
      format.csv { render text: results.to_csv }
    end
  end

  def create
    rendered_time, referer, user = tracking_info
    user.item_results.create!(
      :identifier => params[:identifier],
      :item_id => params[:item_id],
      :rendered_datestamp => rendered_time,
      :referer => referer,
      :ip_address => request.ip,
      :session_status => 'initial')
  end

end