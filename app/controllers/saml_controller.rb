class SamlController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:consume]

  def index
    settings = {
      assertion_consumer_service_url: ENV["assertion_consumer_service_url"]
      issuer: ENV["issuer"]
      idp_sso_target_url: ENV["idp_sso_target_url"]
      idp_cert_fingerprint: ENV["idp_cert_fingerprint"]
      name_identifier_format: ENV["name_identifier_format"]
    }

    request = Onelogin::Saml::Authrequest.new
    redirect_to(request.create(settings))
  end

  def consume
    response = Onelogin::Saml::Response.new(params[:SAMLResponse])
    response.settings = {
      assertion_consumer_service_url: ENV["assertion_consumer_service_url"]
      issuer: ENV["issuer"]
      idp_sso_target_url: ENV["idp_sso_target_url"]
      idp_cert_fingerprint: ENV["idp_cert_fingerprint"]
      name_identifier_format: ENV["name_identifier_format"]
    }

    logger.info "NAMEID: #{response.name_id}"

    if response.is_valid?
      user = User.find_by_email(response.name_id)
      sign_in(:user, user)
      redirect_to user_path(user)
    else
      redirect_to new_user_session
    end
  end
end
