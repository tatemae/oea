ActionMailer::Base.smtp_settings = {
  :user_name => ENV['SENDGRID_USERNAME'],
  :password =>  ENV['SENDGRID_PASSWORD'],
  :domain => "openassessments.com",
  :address => "smtp.sendgrid.net",
  :port => 25,
  :authentication => :plain
}
