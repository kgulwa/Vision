class SessionsController < ApplicationController
  def home
    if logged_in?
      # Feed: pins from followed users + own pins + reposts
      following_ids = current_user.following.pluck(:id)
      @pins = Pin.where(user_id: [current_user.id] + following_ids)
                 .or(Pin.joins(:reposts).where(reposts: { user_id: [current_user.id] + following_ids }))
                 .distinct
                 .recent
                 .limit(50)
    else
      # Show recent pins for non-logged in users
      @pins = Pin.recent.limit(20)
    end
  end

  def new
    # login form
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