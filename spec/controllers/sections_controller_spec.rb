require 'spec_helper'

describe SectionsController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index', :assessment_id => 1
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      get 'show', :assessment_id => 1, :id => 1
      response.should be_success
    end
  end

end
