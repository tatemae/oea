class UserMailer < ActionMailer::Base
	include SendGrid

  default from: "admin@openassessment.com"

  def contact_email(email, name)
  	@name = name.present? ? name : email
  	@url = 'http://www.openassessments.com'
  	mail(to: email, subject: 'Thank you for contacting Open Assessments')
  end
end
