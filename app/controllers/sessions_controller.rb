class SessionsController < ApplicationController

  def home
    # homepage
  end

  def new
    # login form
    # @user here is not strictly needed for login, you could remove it if you prefer
  end

  def create
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Welcome back, #{@user.username}!"
    else
      flash.now[:alert] = "Something went wrong! Make sure your username and password are correct"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged out successfully"
  end

end
