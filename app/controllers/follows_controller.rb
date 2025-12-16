class FollowsController < ApplicationController
  before_action :require_login
  before_action :set_user

  def create
    @user = Follows::Create.call(
      follower: current_user,
      followed: @user
    )

    respond_to do |format|
      format.turbo_stream { render_follow_updates }
      format.html do
        redirect_to user_path(@user),
                    notice: "You are now following #{@user.username}!"
      end
    end
  end

  def destroy
    @user = Follows::Destroy.call(
      follower: current_user,
      followed: @user
    )

    respond_to do |format|
      format.turbo_stream { render_follow_updates }
      format.html do
        redirect_to user_path(@user),
                    notice: "You unfollowed #{@user.username}."
      end
    end
  end

  private

  def set_user
    @user = User.find_by!(uid: params[:user_id])
  end

  def render_follow_updates
    sanitized_uid = @user.uid.delete("-")

    render turbo_stream: [
      turbo_stream.replace(
        "profile_follow_button_#{sanitized_uid}",
        partial: "users/follow_button",
        locals: { user: @user, page: "profile" }
      ),
      turbo_stream.replace(
        "explore_follow_button_#{sanitized_uid}",
        partial: "users/follow_button",
        locals: { user: @user, page: "explore" }
      ),
      turbo_stream.update(
        "profile_follower_count_#{sanitized_uid}",
        @user.followers.count
      ),
      turbo_stream.update(
        "explore_follower_count_#{sanitized_uid}",
        @user.followers.count
      )
    ]
  end
end
