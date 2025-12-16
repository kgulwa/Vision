class SessionsController < ApplicationController
  def home; end

  def new; end

  def create
    @user = Sessions::Authenticate.call(
      username: params[:username],
      password: params[:password]
    )

    if @user
      session[:user_id] = @user.id
      redirect_to pins_path, notice: "Welcome back, #{@user.username}"
    else
      flash.now[:alert] = "Invalid username or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path
  end
end
