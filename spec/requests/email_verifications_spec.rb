require "rails_helper"

RSpec.describe "EmailVerifications", type: :request do
  describe "GET /verify-email" do
    it "verifies the email and redirects" do
      user = create(
        :user,
        email_verified: false,
        email_verification_token: "test-token",
        email_verification_sent_at: Time.current
      )

      get verify_email_path, params: { token: user.email_verification_token }

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(login_path)

      user.reload
      expect(user.email_verified).to be true
      expect(user.email_verification_token).to be_nil
      expect(user.email_verification_sent_at).to be_nil
    end

    it "redirects with alert when token is invalid or expired" do
      get verify_email_path, params: { token: "invalid-token" }

      expect(response).to redirect_to(login_path)
      follow_redirect!

      expect(response.body).to include("Invalid or expired verification link.")
    end
  end
end
