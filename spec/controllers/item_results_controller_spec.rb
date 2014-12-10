require 'spec_helper'

describe ItemResultsController do
  before do

    @identifier = '32477sdfhaf'
    @eid = 'a_unique_external_identifier'
    @src_url = 'http://www.example.com/source_of_quiz'
    @external_user_id = 12
    @keywords = 'math'
    @objectives = 'tolearn'

    @item = FactoryGirl.create(:item)
    @user1 = FactoryGirl.create(:user)

    @item_result1 = @user1.item_results.create!(
      :identifier => @identifier,
      :item_id => @item.id,
      :rendered_datestamp => Time.now-20,
      :datestamp => Time.now,
      :referer => "http://localhost:3000/items/#{@item.id}",
      :ip_address => "127.0.0.1",
      :session_status => 'final',
      :correct => true,
      :item_variable => [{
        "response_variable"=>{
          "id"=>@item.id,
          "correct_response"=>@item.correct_responses,
          "base_type"=>@item.base_type,
          "candidate_response"=>"orange"
        }
      }])

    @user2 = FactoryGirl.create(:user)

    @item_result2 = @user2.item_results.create!(
      :identifier => @identifier,
      :item_id => @item.id,
      :rendered_datestamp => Time.now-10,
      :datestamp => Time.now,
      :referer => "http://localhost:3000/items/#{@item.id}",
      :ip_address => "127.0.0.1",
      :session_status => 'final',
      :correct => true,
      :item_variable => [{
        "response_variable"=>{
          "id"=>@item.id,
          "correct_response"=>@item.correct_responses,
          "base_type"=>@item.base_type,
          "candidate_response"=>"Yellow"
        }
      }])

    @user3 = FactoryGirl.create(:user)

    @item_result3 = @user3.item_results.create!(
      :identifier => @identifier,
      :item_id => @item.id,
      :rendered_datestamp => Time.now-5,
      :datestamp => Time.now,
      :referer => "http://www.bfcoder.com/",
      :ip_address => "127.0.0.1",
      :session_status => 'final',
      :correct => false,
      :item_variable => [{
        "response_variable"=>{
          "id"=>@item.id,
          "correct_response"=>@item.correct_responses,
          "base_type"=>@item.base_type,
          "candidate_response"=>"gold"
        }
      }])

  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index', :identifier => @identifier
      response.should be_success
    end

    it "should find matching item_results" do
      get 'index', :identifier => @identifier
      expect(assigns(:item_results)).to include(@item_result1)
      expect(assigns(:item_results)).to include(@item_result2)
      expect(assigns(:item_results)).to include(@item_result3)
    end

    context "type is summary" do
      
      it "should get the number of renders for that item" do
        get 'index', identifier: @identifier, type: :summary
        expect(assigns(:item_results_summary)[:number_renders]).to eq(@item.item_results.count)
      end

      it "should get the submitted results for that item" do
        get 'index', identifier: @identifier, type: :summary
        expect(assigns(:item_results_summary)[:number_submitted]).to eq(@item.item_results.by_status_final.count)
      end

      it "should get the users for that item result" do
        @users = []
        @item.item_results.map { |ir| @users << ir.user if !@users.include?(ir.user) }
        get 'index', identifier: @identifier, type: :summary
        expect(assigns(:item_results_summary)[:number_of_users]).to eq(@users.length)
      end

      it "should get the referers for that item result" do
        @referers = []
        @referers << "http://www.bfcoder.com/"
        @referers << "http://localhost:3000/items/#{@item.id}"
        get 'index', identifier: @identifier, type: :summary
        expect(assigns(:item_results_summary)[:number_referers]).to eq(@referers.length)
      end

      it "should get the percent correct of responses for that item result" do
        @correct = []
        submitted = @item.item_results.by_status_final
        correct = @item.item_results.by_status_final.find_all{|ir| ir.correct}
        percent_correct = (correct.length.to_f/submitted.length.to_f) * 100
        get 'index', identifier: @identifier, type: :summary
        expect(assigns(:item_results_summary)[:percent_correct]).to eq(percent_correct)
      end

    end

  end

end
