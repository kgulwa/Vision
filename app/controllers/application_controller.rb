class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  stale_when_importmap_changes

  helper_method :current_user, :logged_in?

  before_action :prevent_view_caching

  def current_user
    return @current_user if defined?(@current_user)
    id = session[:user_id]
    @current_user = User.find_by(id: id)
  end

  def logged_in?
    !!current_user
  end

  private

  def require_login
    unless logged_in?
      redirect_to login_path, alert: "You must be logged in to access this page."
    end
  end

  def prevent_view_caching
    response.headers["Cache-Control"] = "no-store" if logged_in?
  end
end
