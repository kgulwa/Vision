require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user) do
    User.create!(
      username: "maileruser",
      email: "mailer@test.com",
      password: "password",
      password_confirmation: "password",
      reset_password_token: "mailtoken"
    )
  end

  it "sends password reset email" do
    mail = described_class.password_reset(user)

    expect(mail.to).to include(user.email)
    expect(mail.subject).to eq("Reset your password")
    expect(mail.body.encoded).to include("reset-password")
  end
end
