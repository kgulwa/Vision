class FollowsController < ApplicationController
  before_action :require_login
  before_action :set_user
  def create
    current_user.follow(@user)
    @user.reload # <-- REFRESH THE FOLLOWERS COUNT
    # Send notification
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
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(
            "follow_button_#{@user.uid.delete('-')}",
            partial: "users/follow_button",
            locals: { user: @user }
          ),
          turbo_stream.update(
            "follower_count_#{@user.uid.delete('-')}",
            @user.followers.count
          )
        ]
      end
      format.html { redirect_to user_path(@user), notice: "You are now following #{@user.username}!" }
    end
  end
  def destroy
    current_user.unfollow(@user)
    @user.reload # <-- REFRESH THE FOLLOWERS COUNT
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(
            "follow_button_#{@user.uid.delete('-')}",
            partial: "users/follow_button",
            locals: { user: @user }
          ),
          turbo_stream.update(
            "follower_count_#{@user.uid.delete('-')}",
            @user.followers.count
          )
        ]
      end
      format.html { redirect_to user_path(@user), notice: "You unfollowed #{@user.username}." }
    end
  end
  private
  def set_user
    @user = User.find_by!(uid: params[:user_id])
  end
end
