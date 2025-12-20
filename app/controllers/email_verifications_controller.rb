class EmailVerificationsController < ApplicationController
  def update
    user = User.find_by(email_verification_token: params[:token])

    if user.nil?
      redirect_to login_path, alert: "Invalid or expired verification link."
      return
    end

    user.update!(
      email_verified: true,
      email_verification_token: nil,
      email_verification_sent_at: nil
    )

    redirect_to login_path, notice: "Your email has been verified. You can now log in."
  end
end
