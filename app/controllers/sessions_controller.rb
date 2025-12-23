class SessionsController < ApplicationController
  def home; end

  def new; end

  def create
    @user = authenticate_user

    return render_invalid_credentials unless @user
    return render_unverified_email unless @user.email_verified

    log_in_user
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path
  end

  private

  def authenticate_user
    Sessions::Authenticate.call(
      username: params[:username],
      password: params[:password]
    )
  end

  def log_in_user
    session[:user_id] = @user.id
    redirect_to pins_path, notice: "Welcome back, #{@user.username}"
  end

  def render_invalid_credentials
    render_with_error("Invalid username or password")
  end

  def render_unverified_email
    render_with_error("Please verify your email before logging in.")
  end

  def render_with_error(message)
    flash.now[:alert] = message
    render :new, status: :unprocessable_entity
  end
end
