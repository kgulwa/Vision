require "rails_helper"

RSpec.describe Auth::SendPasswordReset do
  let!(:user) do
    User.create!(
      username: "konke",
      email: "konke@test.com",
      password: "password",
      password_confirmation: "password"
    )
  end

  it "generates a reset token and timestamp" do
    described_class.call(email: user.email)

    user.reload
    expect(user.reset_password_token).to be_present
    expect(user.reset_password_sent_at).to be_present
  end

  it "returns error when user does not exist" do
    result = described_class.call(email: "missing@test.com")

    expect(result).to be_nil
  end
end
