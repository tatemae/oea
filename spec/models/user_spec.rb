require 'spec_helper'

describe User do

  # it { should have_many :item_results }

  describe "create_anonymous" do
    it "should create a new user with an email and password" do
      user = User.create_anonymous
      user.email.should_not be_blank
    end
  end

end
