class FollowsController < ApplicationController
  before_action :require_login
  before_action :set_user

  def create
    follow(:create, "You are now following #{@user.username}!")
  end

  def destroy
    follow(:destroy, "You unfollowed #{@user.username}.")
  end

  private

  def follow(action, notice_message)
    @user =
      if action == :create
        Follows::Create.call(follower: current_user, followed: @user)
      else
        Follows::Destroy.call(follower: current_user, followed: @user)
      end

    respond_to do |format|
      format.turbo_stream { render_follow_updates }
      format.html { redirect_to user_path(@user), notice: notice_message }
    end
  end

  def set_user
    @user = User.find_by!(uid: params[:user_id])
  end

  def render_follow_updates
    sanitized_uid   = @user.uid.delete("-")
    follower_count  = @user.followers.count

    render turbo_stream: [
      follow_button_stream("profile", sanitized_uid),
      follow_button_stream("explore", sanitized_uid),
      follower_count_stream("profile", sanitized_uid, follower_count),
      follower_count_stream("explore", sanitized_uid, follower_count)
    ]
  end

  def follow_button_stream(page, uid)
    turbo_stream.replace(
      "#{page}_follow_button_#{uid}",
      partial: "users/follow_button",
      locals: { user: @user, page: page }
    )
  end

  def follower_count_stream(page, uid, count)
    turbo_stream.update("#{page}_follower_count_#{uid}", count)
  end
end
