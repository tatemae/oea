class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :signif

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  def after_sign_in_path_for(user)
    user_path(user)
  end

  def skip_trackable
    request.env['devise.skip_trackable'] = true
  end

  def tracking_info
    rendered_time = Time.now
    referer = request.env['HTTP_REFERER']
    if !@user = User.find_by(name: request.session.id)
      @user = User.create_anonymous
      @user.name = request.session.id
      @user.external_id = params[:user_id]
      @user.save!
    end
    [rendered_time, referer, @user]
  end

  def get_domain(url)
    url = "http://#{url}" if URI.parse(url).scheme.nil? rescue nil
    host = URI.parse(url).host.downcase rescue nil
    host
  end

  protected

    def ensure_scheme(url)
      return nil unless url.present?
      url = "http://#{url}" unless url.starts_with?("http") || url.starts_with?('//:')
      url
    end

    def embed_url(assessment)
      api_assessment_url(assessment, format: 'xml')
    end

    def embed_code(assessment, confidence_levels=true, eid=nil)
      url = "#{request.host_with_port}#{assessment_path('load')}?src_url=#{embed_url(assessment)}"
      url = "#{url}&assessment_id=#{assessment.id}" if assessment
      url = "#{url}&confidence_levels=true" if confidence_levels
      url = "#{url}&eid=#{eid}" if eid.present?
      CGI.unescapeHTML(%Q{<iframe src="//#{url}" frameborder="0" style="border:none;width:100%;height:100%;min-height:#{assessment.recommended_height || 400}px;"></iframe>})
    end

    def signif(value, signs)
      Float("%.#{signs}g" % value)
    end

  private

    def authenticate_user_from_token!
      auth_token = params[:auth_token].presence
      user = auth_token && User.find_by(authentication_token: auth_token.to_s)

      if user
        # Notice we are passing store false, so the user is not
        # actually stored in the session and a token is needed
        # for every request. If you want the token to work as a
        # sign in token, you can simply remove store: false.
        sign_in user, store: false
      end
    end

end
