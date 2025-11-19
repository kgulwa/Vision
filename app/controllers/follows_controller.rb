class FollowsController < ApplicationController
  before_action :require_login

  def create
    @user = User.find_by(uid: params[:user_id])
    current_user.follow(@user)
    redirect_to @user, notice: "You are now following #{@user.username}!"
  end

  def destroy
    @user = User.find_by(uid: params[:user_id])
    current_user.unfollow(@user)
    redirect_to @user, notice: "You unfollowed #{@user.username}."
  end

  private

  def require_login
    redirect_to login_path, alert: "You must be logged in to follow users." unless logged_in?
  end
end
