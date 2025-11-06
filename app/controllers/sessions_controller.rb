class SessionsController < ApplicationController
  def home
    if logged_in?
      following_ids = current_user.following.pluck(:id)
      user_and_following_ids = [current_user.id] + following_ids
      pins_from_users = Pin.where(user_id: user_and_following_ids)
      reposted_pins = Pin.joins(:reposts).where(reposts: { user_id: user_and_following_ids })
      @pins = (pins_from_users + reposted_pins).uniq.sort_by(&:created_at).reverse.first(50)
    else
      @pins = Pin.recent.limit(20)
    end
  end

  def new
  end

  def create
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Welcome back, #{@user.username}!"
    else
      flash.now[:alert] = "Invalid username or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged out successfully"
  end
end
