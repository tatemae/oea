class AssessmentLoadersController < ApplicationController

  def create
    vals = {}
    [:eid, :keywords, :style, :confidence_levels, :src_url].each do |k|
      vals[k] = ERB::Util.url_encode(params[k]) unless params[k].blank?
    end
    vals[:load_ui] = true
    redirect_to assessment_path('load', vals)
  end

end
