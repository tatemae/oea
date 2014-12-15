class AssessmentLoadersController < ApplicationController

  def create
    vals = {}
    [:eid, :keywords, :style, :confidence_levels, :src_url].each do |k|
      vals[k] = ERB::Util.url_encode(ensure_decoded(params[k])) unless params[k].blank?
    end
    vals[:load_ui] = true
    redirect_to assessment_path('load', vals)
  end

  private

    def ensure_decoded(encoded)
      decoded = encoded
      begin
        decoded = URI.decode(decoded) 
      end while(decoded != URI.decode(decoded))
      decoded
    end

end
