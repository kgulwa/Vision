class FollowsController < ApplicationController
  before_action :require_login
  before_action :set_user

  def create
    current_user.follow(@user)

    # 🔔 Notify user they gained a follower
    if @user.id != current_user.id
      Notification.create!(
        user: @user,
        actor: current_user,
        action: "started following you",
        notifiable: @user,
        read: false
      )
    end

    redirect_to user_path(@user.id), notice: "You are now following #{@user.username}!"
  end

  def destroy
    current_user.unfollow(@user)
    redirect_to user_path(@user.id), notice: "You unfollowed #{@user.username}."
  end

  private

  def set_user
    @user = User.find_by(id: params[:user_id] || params[:id])
    redirect_to root_path, alert: "User not found" unless @user
  end
end
