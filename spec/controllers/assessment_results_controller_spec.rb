require 'spec_helper'

describe AssessmentResultsController do

  describe "GET 'index'" do
    let(:assessment){ make_assessment }

    it "returns http success" do
      get 'index', :id => assessment.id
      response.should be_success
    end

    it 'should load the items and item results' do
      get 'index', :id => assessment.id
      expect(assigns[:assessment].items.first.item_results.count).to eq 0
    end

    it 'should load the items and item results' do
      get 'index', :id => assessment.id
      expect(assigns[:item_results].items.first.item_results.count).to eq 0
    end
  end

end
