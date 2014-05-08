require 'spec_helper'

describe AssessmentsController do

  before do
    @assessment = make_assessment
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

  describe "POST 'create'" do
    it "sets a license field" do
      sign_in FactoryGirl.create(:user)
      xml_file = Rack::Test::UploadedFile.new File.join(Rails.root, 'spec', 'fixtures', 'assessment.xml')
      assessment = FactoryGirl.attributes_for(:assessment).merge({xml_file: xml_file, license: "foo license"} )
      post 'create', assessment: assessment
      expect(assigns[:assessment].license).to eq("foo license")
    end
  end

end
