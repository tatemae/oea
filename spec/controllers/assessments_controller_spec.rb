require 'spec_helper'

describe AssessmentsController do

  before do
    @assessment = make_assessment
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      get 'show', :id => @assessment.id
      response.should be_success
    end
  end

end
