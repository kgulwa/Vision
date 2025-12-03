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

    respond_to do |format|
      # 🔥 Turbo Stream: updates the follow button only (NO RELOAD)
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "follow_button_#{@user.id}",
          partial: "users/follow_button",
          locals: { user: @user }
        )
      end

      # fallback for non-Turbo clients
      format.html { redirect_to user_path(@user.id), notice: "You are now following #{@user.username}!" }
    end
  end

  def destroy
    current_user.unfollow(@user)

    respond_to do |format|
      # 🔥 Turbo Stream response
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "follow_button_#{@user.id}",
          partial: "users/follow_button",
          locals: { user: @user }
        )
      end

      format.html { redirect_to user_path(@user.id), notice: "You unfollowed #{@user.username}." }
    end
  end

  private

  def set_user
    @user = User.find_by(id: params[:user_id] || params[:id])
    redirect_to root_path, alert: "User not found" unless @user
  end
end
