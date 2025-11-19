class SessionsController < ApplicationController
  def home
  end

  def new
  end

  def create
    @user = User.find_by(username: params[:username])

    if @user&.authenticate(params[:password])
      # ⭐ STORE UUID (uid), NOT numeric id
      session[:user_id] = @user.uid

      redirect_to pins_path
    else
      flash.now[:alert] = "Invalid username or password"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
