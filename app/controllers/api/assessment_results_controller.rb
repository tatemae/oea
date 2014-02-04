class Api::ItemResultsController < ApplicationController

  skip_before_filter :verify_authenticity_token
  before_filter :skip_trackable
  respond_to :json

  # TODO Might have to cheat and make this a index or show so we can use a GET request to record the data. This will avoid cross origin issues.
  def create
    rendered_time, referer, user = tracking_info
    user.assessment_results.create!(
      :assessment_id => params[:assessment_id],
      :rendered_datestamp => rendered_time,
      :referer => referer,
      :ip_address => request.ip,
      :session_status => 'initial')
  end

end