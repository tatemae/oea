require 'spec_helper'

describe Api::AssessmentsController do

  describe "GET 'create'" do
    it "returns http success" do
      post 'create'
      response.should be_success
    end
  end

end
