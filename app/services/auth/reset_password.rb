module Auth
  class ResetPassword < BaseAuthService
    def self.call(token:, password:, password_confirmation:)
      new.call(
        token: token,
        password: password,
        password_confirmation: password_confirmation
      )
    end

    def call(token:, password:, password_confirmation:)
      user = User.find_by(reset_password_token: token)
      return add_error("Invalid token") unless user
      return add_error("Token expired") if token_expired?(user.reset_password_sent_at)

      user.update!(
        password: password,
        password_confirmation: password_confirmation,
        reset_password_token: nil,
        reset_password_sent_at: nil
      )

      user
    end
  end
end
