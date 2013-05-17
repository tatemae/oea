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

  describe 'POST check_answer' do
    before do
      @xml = '<item ident="i4023e1a6889fc13b83d2a6a9991a46d2" title="Question 2"> <itemmetadata> <qtimetadata> <qtimetadatafield> <fieldlabel>question_type</fieldlabel> <fieldentry>multiple_choice_question</fieldentry> </qtimetadatafield> <qtimetadatafield> <fieldlabel>points_possible</fieldlabel> <fieldentry>1</fieldentry> </qtimetadatafield> <qtimetadatafield> <fieldlabel>assessment_question_identifierref</fieldlabel> <fieldentry>ib550dd245ac5e15799afb9245f6548ff</fieldentry> </qtimetadatafield> </qtimetadata> </itemmetadata> <presentation> <material> <mattext texttype="text/html">&lt;div&gt;&lt;p&gt;&lt;img class="equation_image" title="\frac{4}{5}\:?\:\frac{6}{7}" src="https://canvas.instructure.com/equation_images/%255Cfrac%257B4%257D%257B5%257D%255C%253A%253F%255C%253A%255Cfrac%257B6%257D%257B7%257D" alt="\frac{4}{5}\:?\:\frac{6}{7}"&gt;&lt;/p&gt;&lt;/div&gt;</mattext> </material> <response_lid ident="response1" rcardinality="Single"> <render_choice> <response_label ident="1602"> <material> <mattext texttype="text/plain">Greater than (&gt;)</mattext> </material> </response_label> <response_label ident="8292"> <material> <mattext texttype="text/plain">Less than (&lt;)</mattext> </material> </response_label> <response_label ident="2753"> <material> <mattext texttype="text/plain">Equivalent (=)</mattext> </material> </response_label> </render_choice> </response_lid> </presentation> <resprocessing> <outcomes> <decvar maxvalue="100" minvalue="0" varname="SCORE" vartype="Decimal"/> </outcomes> <respcondition continue="No"> <conditionvar> <varequal respident="response1">1602</varequal> </conditionvar> <setvar action="Set" varname="SCORE">100</setvar> </respcondition> </resprocessing> </item>'
      @item = Item.new( xml: @xml )
      @item.save!
    end

    it "handles correct answers" do
      correct_answer_id = 1602
      post :check_answer, { 'name' => @item.id, 'value' => correct_answer_id }
    end

    # it "handles incorrect answers" do
    #   incorrect_answer_id = 8292
    #   post :check_answer, nil, { 'name' => @item.id, 'value' => incorrect_answer_id }
    # end
  end
end
