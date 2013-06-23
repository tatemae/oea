require 'spec_helper'

describe Api::AssessmentsController do
  before do
    @xml = open('./spec/fixtures/test.xml').read
  end

  describe "POST 'create'" do
    it "creates an assessment" do
      request.env['RAW_POST_DATA'] = @xml
      post 'create', format: :xml
      response.should be_success
    end
  end

end
