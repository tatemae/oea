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
      get :index, format: :json, id: @item.id, scope: 'domain', url: 'www.codingfoo.com/index'
      result = JSON.parse(response.body)
      result['item_results'][0]['item_results']['id'].should eq @result3.id
      result['item_results'][1]['item_results']['id'].should eq @result2.id
    end

    it "renders results as csv" do
      get :index, format: :csv, id: @item.id
      result = response.body
    end

    it "renders results as xml" do
      get :index, format: :xml, id: @item.id
      response.body.should include('xml')
    end

    it "scopes summarized results" do
      get :index, format: :json, id: @item.id, type: 'summary', scope: 'page', url: 'www.codingfoo.com/index'
      expect(JSON(response.body)['renders']).to eq 1
    end
  end

end
