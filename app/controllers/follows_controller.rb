class FollowsController < ApplicationController
  before_action :require_login
  before_action :set_user

  def create
    current_user.follow(@user)

    # Notification
    if @user.id != current_user.id
      Notification.create!(
        user: @user,
        actor: current_user,
        action: "started following you",
        notifiable: @user,
        read: false
      )
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to user_path(@user), notice: "You are now following #{@user.username}!" }
    end
  end

  def destroy
    current_user.unfollow(@user)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to user_path(@user), notice: "You unfollowed #{@user.username}." }
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])  # FIXED!
  end
end
