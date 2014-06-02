require 'spec_helper'

describe Api::AssessmentResultsController do

  describe "POST create" do
    it "creates an assessment result" do
      assessment_result = FactoryGirl.build(:assessment_result)
      post :create, id: assessment_result.id, eid: "foo", format: :json
      expect(AssessmentResult.first).to_not be(nil)
      expect(AssessmentResult.first.eid).to eq("foo")
    end
  end

end
