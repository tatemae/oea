require 'spec_helper'

describe SectionsController do
  before do
    @xml = open('./spec/fixtures/assessment.xml').read
    @assessment = Assessment.new
    @assessment.from_xml(@xml)
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index', :assessment_id => @assessment.id
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      get 'show', :assessment_id => @assessment.id, :id => @assessment.sections.first.id
      response.should be_success
    end
  end

end
