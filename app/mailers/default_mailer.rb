class DefaultMailer < ActionMailer::Base

  def mail_from_params(options)
    options[:to] ||= ENV["admin_email"]
    options[:from] ||= ENV["from_email"]
    mail(options)
  end

end
