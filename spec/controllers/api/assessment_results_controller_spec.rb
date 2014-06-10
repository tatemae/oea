require 'spec_helper'

describe Api::AssessmentResultsController do

  describe "POST create" do
    it "creates an assessment result" do
      assessment_result = FactoryGirl.build(:assessment_result)
      post :create, id: assessment_result.id, eid: "foo", format: :json
      expect(AssessmentResult.first).to_not be(nil)
      expect(AssessmentResult.first.eid).to eq("foo")
    end
    it "creates an assessment result with an src url" do
      assessment_result = FactoryGirl.build(:assessment_result)
      post :create, id: assessment_result.id, src_url: "foo", format: :json
      expect(AssessmentResult.first).to_not be(nil)
      expect(AssessmentResult.first.src_url).to eq("foo")
    end
    it "creates an assessment result with an src url" do
      assessment_result = FactoryGirl.build(:assessment_result)
      post :create, id: assessment_result.id, identifier: "foo", format: :json
      expect(AssessmentResult.first).to_not be(nil)
      expect(AssessmentResult.first.identifier).to eq("foo")
    end
    it "creates an assessment result with keywords" do
      assessment_result = FactoryGirl.build(:assessment_result)
      post :create, id: assessment_result.id, keywords: "foo, bar", format: :json
      expect(AssessmentResult.first).to_not be(nil)
      expect(AssessmentResult.first.keyword_list).to eq(["foo", "bar"])
    end
  end

end
