require 'spec_helper'

describe Api::ItemResultsController do
  before do
    @item = FactoryGirl.create(:item)
    @result1 = FactoryGirl.create(:item_result, item: @item)
    @result2 = FactoryGirl.create(:item_result, item: @item, referer: 'www.codingfoo.com')
  end

  describe "GET 'index'" do
    it "returns http success" do
      get :index, format: :json, id: @item.id
      response.should be_success
    end

    it "scopes results" do
      result = { item_results: [ { item_results: @result2 } ] }
      get :index, format: :json, id: @item.id, scope: 'domain', url: 'www.codingfoo.com'
      expect(response.body).to eq result.to_json
    end
  end

end
