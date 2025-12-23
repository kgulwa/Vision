class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  helper_method :current_user, :logged_in?

  before_action :prevent_view_caching

  # Return the currently logged-in user (or nil)
  def current_user
    return @current_user if defined?(@current_user)

    user_id = session[:user_id]
    @current_user = user_id && User.find_by(id: user_id)
  end

  # Boolean for login status
  def logged_in?
    current_user.present?
  end

  private

  def require_login
    return if logged_in?

    redirect_to login_path, alert: "You must be logged in to access this page."
  end

  # Prevents caching pages when user is logged in
  def prevent_view_caching
    response.headers["Cache-Control"] = "no-store" if logged_in?
  end
end
