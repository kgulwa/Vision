class SessionsController < ApplicationController
  def home; end

  def new; end

  def create
    @user = Sessions::Authenticate.call(
      username: params[:username],
      password: params[:password]
    )

    unless @user
      flash.now[:alert] = "Invalid username or password"
      render :new, status: :unprocessable_entity
      return
    end

    unless @user.email_verified
      flash.now[:alert] = "Please verify your email before logging in."
      render :new, status: :unprocessable_entity
      return
    end

    session[:user_id] = @user.id
    redirect_to pins_path, notice: "Welcome back, #{@user.username}"
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path
  end
end
