require 'spec_helper'

describe "items/index.html.erb" do
  describe "items/index" do
    it "renders _item partial for each item" do
      assign(:items, [stub_model(Item), stub_model(Item)])
      render
      expect(view).to render_template(:partial => "_item", :count => 2)
    end
  end
end
