require 'spec_helper'

describe Api::ItemResultsController do
  before do
    @item = FactoryGirl.create(:item)
    @result1 = FactoryGirl.create(:item_result, item: @item)
    @result2 = FactoryGirl.create(:item_result, item: @item, referer: 'www.codingfoo.com')
    @result3 = FactoryGirl.create(:item_result, item: @item, referer: 'www.codingfoo.com/index.html')
  end

  describe "GET 'index'" do
    it "returns http success" do
      get :index, format: :json, id: @item.id
      response.should be_success
    end

    it "scopes results" do
      result = { item_results: [ { item_results: @result3 }, { item_results: @result2 } ]   }
      get :index, format: :json, id: @item.id, scope: 'domain', url: 'www.codingfoo.com/index'
      expect(response.body).to eq result.to_json
    end

    it "scopes summarized results" do
      get :index, format: :json, id: @item.id, type: 'summary', scope: 'page', url: 'www.codingfoo.com/index'
      expect(JSON(response.body)['renders']).to eq 1
    end
  end

end
