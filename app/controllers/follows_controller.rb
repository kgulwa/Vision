class FollowsController < ApplicationController
  before_action :require_login
  before_action :set_user

  def create
    current_user.follow(@user)
    redirect_to user_path(@user.uid), notice: "You are now following #{@user.username}!"
  end

  def destroy
    current_user.unfollow(@user)
    redirect_to user_path(@user.uid), notice: "You unfollowed #{@user.username}."
  end

  private

  def set_user
    uid = params[:user_uid] || params[:uid] || params[:id]
    @user = User.find_by(uid: uid)

    if @user.nil?
      redirect_to root_path, alert: "User not found"
    end
  end
end
