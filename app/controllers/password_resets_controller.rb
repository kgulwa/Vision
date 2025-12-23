class PasswordResetsController < ApplicationController
  def new
  end

  def create
    result = Auth::SendPasswordReset.call(email: params[:email])

    if result
      redirect_to login_path, notice: "If that email exists, a reset link has been sent."
    else
      flash.now[:alert] = "Unable to send reset email"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @token = params[:token]
  end

  def update
    result = Auth::ResetPassword.call(
      token: params[:token],
      password: params[:password],
      password_confirmation: params[:password_confirmation]
    )

    if result
      redirect_to login_path, notice: "Your password has been reset. Please log in."
    else
      flash.now[:alert] = "Reset link is invalid or expired"
      render :edit, status: :unprocessable_entity
    end
  end
end
