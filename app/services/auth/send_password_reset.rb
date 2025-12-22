module Auth
  class SendPasswordReset < BaseAuthService
    def self.call(email:)
      new.call(email: email)
    end

    def call(email:)
      user = User.find_by(email: email)

      return add_error("User not found") unless user

      token = generate_token

      user.update!(
        reset_password_token: token,
        reset_password_sent_at: Time.current
      )

      UserMailer.password_reset(user).deliver_later

      user
    end
  end
end
