class SessionsController < ApplicationController
  def home; end

  def new; end

  def create
    @user = User.find_by(username: params[:username])

    if @user&.authenticate(params[:password])
      session[:user_uid] = @user.uid
      redirect_to pins_path, notice: "Welcome back, #{@user.username}"
    else
      flash.now[:alert] = "Invalid username or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_uid)
    redirect_to root_path
  end
end
