require 'spec_helper'

describe Api::ItemsController do

  describe "GET 'index'" do
    it "returns http success" do
      FactoryGirl.create(:item)
      get 'index', format: :json, q: 'Question'
      response.should be_success
    end
  end

  describe "create" do
  end

end
