require 'spec_helper'

describe AssessmentResultsController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index', :assessment_id => 1
      response.should be_success
    end
  end

end