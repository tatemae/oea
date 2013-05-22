require 'spec_helper'

describe Api::ResultsController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index', format: :json
      response.should be_success
    end
  end

end
