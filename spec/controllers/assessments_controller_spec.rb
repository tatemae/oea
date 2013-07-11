require 'spec_helper'

describe AssessmentsController do

  before do
    @xml = open('./spec/fixtures/assessment.xml').read
    @assessment = Assessment.new
    @assessment.from_xml(@xml)
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      get 'show', :id => @assessment.id
      response.should be_success
    end
  end

end
