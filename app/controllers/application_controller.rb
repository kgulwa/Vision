class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  helper_method :current_user, :logged_in?

  before_action :prevent_view_caching

  # Return the currently logged-in user (or nil)
  def current_user
    return @current_user if defined?(@current_user)

    if session[:user_id].present?
      @current_user = User.find_by(id: session[:user_id])
    else
      @current_user = nil
    end
  end

  # Boolean for login status
  def logged_in?
    !!current_user
  end

  private

  # 🔐 SAFEST version of login requirement
  # avoids `.empty?` problems and RSpec failures
  def require_login
    unless logged_in?
      redirect_to login_path, alert: "You must be logged in to access this page."
    end
  end

  # Prevents caching pages when user is logged in
  def prevent_view_caching
    response.headers["Cache-Control"] = "no-store" if logged_in?
  end
end
