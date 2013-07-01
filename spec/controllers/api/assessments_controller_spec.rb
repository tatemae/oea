require 'spec_helper'

describe Api::AssessmentsController do
  before do
    @xml = open('./spec/fixtures/test.xml').read
  end

  describe "GET 'index'" do
    it "returns http success" do
      FactoryGirl.create(:assessment)
      get 'index', format: :json, q: 'Question'
      response.should be_success
    end
  end

  describe "POST 'create'" do
    it "creates an assessment xml" do
      request.env['RAW_POST_DATA'] = @xml
      post 'create', format: :xml
      response.should be_success
    end
    it "creates an assessment json" do
      request.env['RAW_POST_DATA'] = @xml
      post 'create', format: :json
      response.should be_success
    end
  end

end
