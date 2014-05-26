require "spec_helper"

describe UserMailer do
	include EmailSpec::Helpers
  include EmailSpec::Matchers
  before do
    @user = FactoryGirl.create(:user)
  end
  
  subject { UserMailer.contact_email(@user.email, @user.name).deliver }

  it { should deliver_from "admin@openassessment.com" }
  it { should deliver_to @user.email }
  it { should have_subject Regexp.new("Thank you for contacting Open Assessments") }
end
