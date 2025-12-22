module Auth
  class BaseAuthService < Services::BaseService
    protected

    def generate_token
      SecureRandom.urlsafe_base64(32)
    end

    def token_expired?(sent_at, expires_in: 2.hours)
      sent_at < expires_in.ago
    end
  end
end
