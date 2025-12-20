require "rails_helper"

RSpec.describe Users::EmailVerificationService do
  describe "#call" do
    it "generates a verification token and timestamp" do
      user = create(:user)

      described_class.new(user).call

      user.reload

      expect(user.email_verification_token).to be_present
      expect(user.email_verification_sent_at).to be_present
    end
  end
end
