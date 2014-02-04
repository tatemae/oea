class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

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

end
