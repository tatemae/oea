require "spec_helper"

describe DefaultMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers
  before do
    @user = FactoryGirl.create(:user)
  end

  subject { DefaultMailer.mail_from_params(:subject => "Thanks for your inquiry from #{ENV['application_name']}!", :body=>"utf8: ✓\nname: james\nemail: #{@user.email}\nsubject: howdy\nmessage: my friend\ncommit: SEND").deliver }

  it { should deliver_from "#{ENV['support_email']}" }
  it { should deliver_to ENV["admin_email"] }
  it { should have_subject Regexp.new("Thanks for your inquiry from #{ENV['application_name']}!") }
end
