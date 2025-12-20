require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "email_verification" do
    let(:user) do
      create(
        :user,
        email: "user@example.com",
        email_verified: false,
        email_verification_token: "test-token"
      )
    end

    let(:mail) { UserMailer.email_verification(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Verify your email address")
      expect(mail.to).to eq(["user@example.com"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include("Verify your email")
      expect(mail.body.encoded).to include("test-token")
    end
  end
end
