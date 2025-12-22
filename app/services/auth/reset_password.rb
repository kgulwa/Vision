module Auth
  class ResetPassword < BaseAuthService
    def self.call(token:, password:)
      new.call(token: token, password: password)
    end

    def call(token:, password:)
      user = User.find_by(reset_password_token: token)

      return add_error("Invalid token") unless user
      return add_error("Token expired") if token_expired?(user.reset_password_sent_at)

      user.update!(
        password: password,
        reset_password_token: nil,
        reset_password_sent_at: nil
      )

      user
    end
  end
end
