class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  stale_when_importmap_changes

  helper_method :current_user, :logged_in?

  before_action :prevent_view_caching

  private

  # Use UID instead of ID to find the current user
  def current_user
    @current_user ||= User.find_by(uid: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_login
    unless logged_in?
      redirect_to login_path, alert: "You must be logged in to access this page."
    end
  end

  def prevent_view_caching
    response.headers["Cache-Control"] = "no-store" if logged_in?
  end
end
