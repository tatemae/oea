require 'spec_helper'

describe OembedController do
  before do
    @user = FactoryGirl.create(:user)
  end
  describe "endpoint" do
    context "assessment" do
      before do
        @assessment = FactoryGirl.create(:assessment, :user => @user)
        @url = CGI.escape(assessment_url(@assessment))
      end
      it "should return json for the given assessment" do
        get :endpoint, :url => @url, :format => 'json'
        response.should be_success
        result = JSON.parse(response.body)
        result['title'].should == @assessment.title
        result['author_name'].should == @assessment.user.display_name
      end
    end
  end

end