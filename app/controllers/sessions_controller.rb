class SessionsController < ApplicationController
  def home
    if logged_in?
      following_uids = current_user.following.pluck(:uid)
      all_uids = [current_user.uid] + following_uids

      own_and_following_pins = Pin.where(user_uid: all_uids)
      reposted_pin_ids = Repost.where(user_uid: all_uids).pluck(:pin_id)
      reposted_pins = Pin.where(id: reposted_pin_ids)

      @pins = (own_and_following_pins + reposted_pins).uniq.sort_by(&:created_at).reverse.first(50)
    else
      @pins = Pin.recent.limit(20)
    end
  end

  def new; end

  def create
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.uid
      redirect_to root_path, notice: "Welcome back, #{@user.username}!"
    else
      flash.now[:alert] = "Invalid username or password"
      render :new, status: :unprocessable_content
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged out successfully"
  end
end
