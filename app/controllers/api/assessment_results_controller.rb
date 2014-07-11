class Api::AssessmentResultsController < ApplicationController

  skip_before_filter :verify_authenticity_token
  before_filter :skip_trackable
  respond_to :json

  # TODO Might have to cheat and make this a index or show so we can use a GET request to record the data. This will avoid cross origin issues.
  def create
    rendered_time, referer, user = tracking_info
    assessment_result = user.assessment_results.create!(
      assessment_id: params[:assessment_id],
      eid: params[:eid],
      src_url: params[:src_url],
      external_user_id: params[:external_user_id],
      identifier: params['identifier'],
      rendered_datestamp: rendered_time,
      referer: referer,
      ip_address: request.ip,
      session_status: 'initial')

    assessment_result.keyword_list.add(params[:keywords], parse: true) if params[:keywords]
    assessment_result.objective_list.add(params[:objectives], parse: true) if params[:objectives]
    assessment_result.save! if params[:objectives] || params[:keywords]
    respond_with(:api, assessment_result)
  end

end
