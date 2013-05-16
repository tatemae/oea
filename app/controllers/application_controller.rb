class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def item_content(content)
    CGI.unescapeHTML(CGI.unescape(content.to_html)).html_safe
  end
  helper_method :item_content
end
