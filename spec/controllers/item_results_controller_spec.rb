require 'spec_helper'

describe ItemResultsController do
  before do

    @item = FactoryGirl.create(:item)
    @user1 = FactoryGirl.create(:user)

    @item_result1 = @user1.item_results.create!(
      :identifier => @item.identifier,
      :item_id => @item.id,
      :rendered_datestamp => Time.now-20,
      :datestamp => Time.now,
      :referer => "http://localhost:3000/items/#{@item.id}",
      :ip_address => "127.0.0.1",
      :session_status => 'final',
      :item_variable => [{
        "response_variable"=>{
          "id"=>@item.id,
          "correct_response"=>@item.correct_responses,
          "base_type"=>@item.base_type,
          "candidate_response"=>"8292"
        }
      }])

    @user2 = FactoryGirl.create(:user)

    @item_result2 = @user2.item_results.create!(
      :identifier => @item.identifier,
      :item_id => @item.id,
      :rendered_datestamp => Time.now-10,
      :datestamp => Time.now,
      :referer => "http://localhost:3000/items/#{@item.id}",
      :ip_address => "127.0.0.1",
      :session_status => 'final',
      :item_variable => [{
        "response_variable"=>{
          "id"=>@item.id,
          "correct_response"=>@item.correct_responses,
          "base_type"=>@item.base_type,
          "candidate_response"=>"3053"
        }
      }])

    @user3 = FactoryGirl.create(:user)

    @item_result3 = @user3.item_results.create!(
      :identifier => @item.identifier,
      :item_id => @item.id,
      :rendered_datestamp => Time.now-5,
      :datestamp => Time.now,
      :referer => "http://www.bfcoder.com/",
      :ip_address => "127.0.0.1",
      :session_status => 'final',
      :item_variable => [{
        "response_variable"=>{
          "id"=>@item.id,
          "correct_response"=>@item.correct_responses,
          "base_type"=>@item.base_type,
          "candidate_response"=>"2753"
        }
      }])
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index', :assessment_id => 1, :section_id => 1, :item_id => @item.id
      response.should be_success
    end

    it "should get the item it belongs to" do
      get 'index', :item_id => @item.id, :assessment_id => 1, :section_id => 1
      expect(assigns(:item)).to eq(@item)
    end

    it "should get the number of renders for that item" do
      get 'index', :item_id => @item.id, :assessment_id => 1, :section_id => 1
      expect(assigns(:item).results_summary[:renders]).to eq(@item.item_results.count)
    end

    it "should get the submitted results for that item" do
      get 'index', :item_id => @item.id, :assessment_id => 1, :section_id => 1
      expect(assigns(:item).results_summary[:submitted]).to eq(@item.item_results.by_status_final)
    end

    it "should get the users for that item result" do
      @users = []
      @item.item_results.map { |ir| @users << ir.user if !@users.include?(ir.user) }
      get 'index', :item_id => @item.id, :assessment_id => 1, :section_id => 1
      expect(assigns(:item).results_summary[:users]).to eq(@users)
    end

    it "should get the referers for that item result" do
      @referers = []
      @referers << "http://localhost:3000/items/#{@item.id}"
      @referers << "http://www.bfcoder.com/"
      get 'index', :item_id => @item.id, :assessment_id => 1, :section_id => 1
      expect(assigns(:item).results_summary[:referers]).to eq(@referers)
    end

    it "should get the correct responses for that item result" do
      @correct = []
      @correct << @item_result2
      get 'index', :item_id => @item.id, :assessment_id => 1, :section_id => 1
      expect(assigns(:item).results_summary[:correct]).to eq(@correct)
    end

    it "should get the percent correct of responses for that item result" do
      @correct = []
      @submitted = @item.item_results.by_status_final
      @percent_correct = 1.0/3.0
      get 'index', :item_id => @item.id, :assessment_id => 1, :section_id => 1
      expect(assigns(:item).results_summary[:percent_correct]).to eq(@percent_correct)
    end

  end

end
