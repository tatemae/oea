class SamlController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:consume]

  def index
    require 'onelogin/saml'
    request = Onelogin::Saml::AuthRequest.new(saml_settings)
    redirect_to(request.generate_request)
  end

  def consume
    require 'onelogin/saml'
    response = Onelogin::Saml::Response.new(params[:SAMLResponse])
    response.settings = saml_settings

    logger.info "NAMEID: #{response.name_id}"

    if response.is_valid?
      user = User.find_by_email(response.name_id)
      sign_in(:user, user)
      redirect_to user_path(user)
    else
      redirect_to new_user_session
    end
  end

  def metadata
    require 'onelogin/saml'
    # This needs to be publicly available since external SAML
    # servers need to be able to access it without being authenticated.
    # It is used to disclose our SAML configuration settings.
    render :xml => Onelogin::Saml::MetaData.create(saml_settings)
  end

  private

  def saml_settings
    saml_settings = Onelogin::Saml::Settings.new
    saml_settings.sp_slo_url = ENV["saml_logout_url"]
    saml_settings.assertion_consumer_service_url = ENV["assertion_consumer_service_url"]
    saml_settings.issuer = ENV["issuer"]
    saml_settings.tech_contact_name = ENV["tech_contact_name"]
    saml_settings.tech_contact_email = ENV["tech_contact_email"]
    saml_settings.idp_sso_target_url = ENV["idp_sso_target_url"]
    saml_settings.idp_cert_fingerprint = ENV["idp_cert_fingerprint"]
    saml_settings.name_identifier_format = ENV["name_identifier_format"]
    saml_settings.xmlsec_certificate = resolve_path(ENV["saml_certificate"])
    saml_settings.xmlsec_privatekey = resolve_path(ENV["saml_private_key"])

    saml_settings
  end

  def resolve_path(path)
    return nil unless path

    path = Pathname(path)

    if path.relative?
      path = Rails.root.join path
    end

    path.exist? ? path.to_s : nil
  end
end
