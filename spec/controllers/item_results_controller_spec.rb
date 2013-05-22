require 'spec_helper'

describe ItemResultsController do
  before do
    @xml = '<item ident="i4023e1a6889fc13b83d2a6a9991a46d2" title="Question 2"> <itemmetadata> <qtimetadata> <qtimetadatafield> <fieldlabel>question_type</fieldlabel> <fieldentry>multiple_choice_question</fieldentry> </qtimetadatafield> <qtimetadatafield> <fieldlabel>points_possible</fieldlabel> <fieldentry>1</fieldentry> </qtimetadatafield> <qtimetadatafield> <fieldlabel>assessment_question_identifierref</fieldlabel> <fieldentry>ib550dd245ac5e15799afb9245f6548ff</fieldentry> </qtimetadatafield> </qtimetadata> </itemmetadata> <presentation> <material> <mattext texttype="text/html">&lt;div&gt;&lt;p&gt;&lt;img class="equation_image" title="\frac{4}{5}\:?\:\frac{6}{7}" src="https://canvas.instructure.com/equation_images/%255Cfrac%257B4%257D%257B5%257D%255C%253A%253F%255C%253A%255Cfrac%257B6%257D%257B7%257D" alt="\frac{4}{5}\:?\:\frac{6}{7}"&gt;&lt;/p&gt;&lt;/div&gt;</mattext> </material> <response_lid ident="response1" rcardinality="Single"> <render_choice> <response_label ident="1602"> <material> <mattext texttype="text/plain">Greater than (&gt;)</mattext> </material> </response_label> <response_label ident="8292"> <material> <mattext texttype="text/plain">Less than (&lt;)</mattext> </material> </response_label> <response_label ident="2753"> <material> <mattext texttype="text/plain">Equivalent (=)</mattext> </material> </response_label> </render_choice> </response_lid> </presentation> <resprocessing> <outcomes> <decvar maxvalue="100" minvalue="0" varname="SCORE" vartype="Decimal"/> </outcomes> <respcondition continue="No"> <conditionvar> <varequal respident="response1">1602</varequal> </conditionvar> <setvar action="Set" varname="SCORE">100</setvar> </respcondition> </resprocessing> </item>'
    @item = Item.new( xml: @xml )
    @item.save!

    @user1 = User.create_anonymous
    @user1.name = "6a8154c6b66bff391862721011537c63234wwqesadf"
    @user1.save!

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
          "correct_response"=>@item.correct_response,
          "base_type"=>@item.base_type,
          "candidate_response"=>8292
        }
      }])

    @user2 = User.create_anonymous
    @user2.name = "6a8154c6b66bff391862721011537c63sadfasdf"
    @user2.save!

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
          "correct_response"=>@item.correct_response,
          "base_type"=>@item.base_type,
          "candidate_response"=>1602
        }
      }])

    @user3 = User.create_anonymous
    @user3.name = "6a8154c6b66bff391862721011537c63sfd90sdfj"
    @user3.save!

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
          "correct_response"=>@item.correct_response,
          "base_type"=>@item.base_type,
          "candidate_response"=>2753
        }
      }])
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index', :item_id => @item.id
      response.should be_success
    end

    it "should get the item it belongs to" do
      get 'index', :item_id => @item.id
      expect(assigns(:item)).to eq(@item)
    end

    it "should get the number of renders for that item" do
      get 'index', :item_id => @item.id
      expect(assigns(:item).results_summary[:renders]).to eq(@item.item_results.count)
    end

    it "should get the submitted results for that item" do
      get 'index', :item_id => @item.id
      expect(assigns(:item).results_summary[:submitted]).to eq(@item.item_results.by_status_final)
    end

    it "should get the users for that item result" do
      get 'index', :item_id => @item.id
      @users = []
      @item.item_results.map { |ir| @users << ir.user if !@users.include?(ir.user) }
      expect(assigns(:item).results_summary[:users]).to eq(@users)
    end

    it "should get the referers for that item result" do
      get 'index', :item_id => @item.id
      @referers = []
      @referers << "http://localhost:3000/items/#{@item.id}"
      @referers << "http://www.bfcoder.com/"
      expect(assigns(:item).results_summary[:referers]).to eq(@referers)
    end

    it "should get the correct responses for that item result" do
      get 'index', :item_id => @item.id
      @correct = []
      @correct << @item_result2
      expect(assigns(:item).results_summary[:correct]).to eq(@correct)
    end

    it "should get the percent correct of responses for that item result" do
      get 'index', :item_id => @item.id
      @correct = []
      @submitted = @item.item_results.by_status_final
      @percent_correct = 1.0/3.0
      expect(assigns(:item).results_summary[:percent_correct]).to eq(@percent_correct)
    end

  end

end
