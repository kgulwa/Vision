module ApplicationHelper
  def logged_in?
    session[:user_uid].present? || session[:user_id].present?
  end

  def current_user
    uid = session[:user_uid] || session[:user_id]
    @current_user ||= User.find_by(uid: uid)
  end
end
