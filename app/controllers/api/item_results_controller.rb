class Api::ItemResultsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :skip_trackable
  respond_to :json, :csv, :xml

  def index
    scope_url = params[:url]
    scope_url = get_domain(scope_url) if params[:scope] == 'domain'
    identifier = params[:identifer] if params[:identifer]
    eid = params[:eid] if params[:eid]
    keyword = params[:keyword] if params[:keyword]
    external_user_id = params[:external_user_id] if params[:external_user_id]
    src_url = params[:src_url] if params[:src_url]
    objective = params[:objectives] if params[:objectives]
    if params[:type] == 'summary'
      results = Item.results_summary( scope_url: scope_url, identifier: identifier, eid: eid, keyword: keyword, objective: objective, external_user_id: external_user_id, src_url: src_url )
    else
      results = Item.raw_results( scope_url: scope_url, identifier: identifier, eid: eid, keyword: keyword, objective: objective, external_user_id: external_user_id, src_url: src_url )
    end
    respond_to do |format|
      format.json { render json: results }
      format.xml { render xml: results }
      format.csv { render text: results.to_csv }
    end
  end

  def create
    rendered_time, referer, user = tracking_info
    item_result = user.item_results.create!(
      identifier: params[:identifier],
      item_id: params[:item_id],
      src_url: params[:src_url],
      external_user_id: params[:external_user_id],
      assessment_result_id: params[:assessment_result_id],
      eid: params[:eid],
      rendered_datestamp: rendered_time,
      referer: referer,
      ip_address: request.ip,
      time_elapsed: params['time_elapsed'],
      confidence_level: convert_confidence_level,
      session_status: params[:session_status] || 'initial')

    item_result.keyword_list.add(params[:keywords], parse: true) if params[:keywords]
    item_result.objective_list.add(params[:objectives], parse: true) if params[:objectives]
    item_result.save! if params[:objectives] || params[:keywords]

    respond_with(:api, item_result)
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
