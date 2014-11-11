require 'spec_helper'

describe AssessmentLoadersController do

  describe "POST create" do
    it "should redirect to the assessment load path" do
      src_url = "http://www.example.com"
      eid = ''
      confidence_levels = 'true'
      post 'create', src_url: src_url, eid: eid, confidence_levels: confidence_levels
      expect(response).to redirect_to(assessment_path('load', eid: eid, confidence_levels: confidence_levels, src_url: ERB::Util.url_encode(src_url)))
    end
  end

end
