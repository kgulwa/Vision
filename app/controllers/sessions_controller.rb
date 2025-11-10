class SessionsController < ApplicationController

  def home
    if logged_in?
      # Feed: pins from followed users + own pins + reposts
      following_ids = current_user.following.pluck(:id)
      all_user_ids = [current_user.id] + following_ids
      
      # Get pins from users we follow and our own pins
      own_and_following_pins = Pin.where(user_id: all_user_ids)
      
      # Get pins that were reposted by us or people we follow
      reposted_pin_ids = Repost.where(user_id: all_user_ids).pluck(:pin_id)
      reposted_pins = Pin.where(id: reposted_pin_ids)
      
      # Combine and remove duplicates
      @pins = (own_and_following_pins + reposted_pins).uniq.sort_by(&:created_at).reverse.first(50)
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
      render :new, status: :unprocessable_content
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged out successfully"
  end

end