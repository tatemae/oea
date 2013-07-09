require 'spec_helper'

describe ItemsController do

  before do
    @xml = open('./spec/fixtures/assessment.xml').read
    @assessment = Assessment.new( xml: @xml )
    @assessment.save!
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index', :assessment_id => @assessment.id, :section_id => @assessment.sections.first.id
      response.should be_success
    end
    it "assigns @items" do
      get :index, :assessment_id => @assessment.id, :section_id => @assessment.sections.first.id
      expect(assigns(:items)).to eq(@assessment.items)
    end
  end

  describe 'POST check_answer' do
    before do
      @item = FactoryGirl.create(:item)
    end

    it "handles correct answers" do
      correct_answer_id = "3053"
      post :check_answer, { :format => 'json', 'item' => {:id => @item.id}, "#{@item.id}" => correct_answer_id }
      response.should be_success
      body = JSON.parse(response.body)
      body.should include('correct')
      correct = body['correct']
      correct.should be_true
    end

    it "creates a user based on session" do
      correct_answer_id = "3053"
      user = User.create_anonymous
      user.name = "asdfasdf"
      user.save!
      post :check_answer, { :format => 'json', 'item' => {:id => @item.id}, "#{@item.id}" => correct_answer_id }
      User.last.should_not == user
    end

    it "handles incorrect answers" do
      incorrect_answer_id = "8292"
      post :check_answer, { :format => 'json', 'item' => {:id => @item.id}, "#{@item.id}" => incorrect_answer_id }
      response.should be_success
      body = JSON.parse(response.body)
      body.should include('correct')
      correct = body['correct']
      correct.should be_false
    end
  end
end
