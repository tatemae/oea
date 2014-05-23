ActionMailer::Base.smtp_settings = {
  :user_name => ENV['sendgrid_username'],
  :password =>  ENV['sendgrid_password'],
  :domain => "openassessments.com",
  :address => ENV['email_server_address'],
  :port => 25,
  :authentication => :plain
}
