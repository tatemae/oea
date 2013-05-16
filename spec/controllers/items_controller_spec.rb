require 'spec_helper'

describe ItemsController do
  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
    it "assigns @items" do
      item1, item2 = Item.create!, Item.create!
      get :index
      expect(assigns(:items)).to match_array([item1, item2])
    end
  end
end
