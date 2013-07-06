require 'spec_helper'

describe Api::ItemResultsController do
  before do
    @item = Item.new
    @item.save!
  end

  describe "GET 'index'" do
    it "returns http success" do
      get :index, format: :json, id: @item.id
      response.should be_success
    end
  end

end
