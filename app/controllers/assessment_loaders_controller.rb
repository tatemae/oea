class AssessmentLoadersController < ApplicationController

  def create
    redirect_to assessment_path('load', eid: params[:eid], confidence_levels: params[:confidence_levels], src_url: ERB::Util.url_encode(params[:src_url]))
  end

end
