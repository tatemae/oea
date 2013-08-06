require 'spec_helper'

describe AssessmentResultsController do

  describe "GET 'index'" do
    it "returns http success" do
      assessment = Assessment.create! title: "foo title"
      get 'index', :id => assessment.id
      response.should be_success
    end
  end

end
