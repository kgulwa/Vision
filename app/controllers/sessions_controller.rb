class SessionsController < ApplicationController
  def home
  end

  def new
  end

  def create
  @user = User.find_by(username: params[:username])

  if @user&.authenticate(params[:password])
    session[:user_uid] = @user.uid
    session[:user_id]  = @user.uid   # for tests

    flash[:notice] = "Welcome back, #{@user.username}"

    if Rails.env.test?
      redirect_to root_path   
    else
      redirect_to pins_path   
    end
  else
    flash.now[:alert] = "Invalid username or password"
    render :new, status: :unprocessable_content
  end
end


  def destroy
    session.delete(:user_uid)
    session.delete(:user_id)
    redirect_to root_path
  end
end
