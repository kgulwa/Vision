module Users
  class EmailVerificationService
    def initialize(user)
      @user = user
    end

    def call
      @user.update!(
        email_verification_token: SecureRandom.urlsafe_base64(32),
        email_verification_sent_at: Time.current
      )
    end

    private

    attr_reader :user
  end
end
