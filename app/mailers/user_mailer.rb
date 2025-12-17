class UserMailer < ApplicationMailer
  def email_verification(user)
    @user = user
    @verification_url = verify_email_url(token: user.email_verification_token)

    mail(
      to: @user.email,
      subject: "Verify your email address"
    )
  end
end
