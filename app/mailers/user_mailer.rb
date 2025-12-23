class UserMailer < ApplicationMailer
  def email_verification(user)
    @user = user
    @verification_url = verify_email_url(token: user.email_verification_token)

    mail(
      to: @user.email,
      subject: "Verify your email address"
    )
  end

  def password_reset(user)
    @user = user
    @reset_url = reset_password_url(token: user.reset_password_token)

    mail(
      to: @user.email,
      subject: "Reset your password"
    )
  end
end
