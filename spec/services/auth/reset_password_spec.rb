require "rails_helper"

RSpec.describe Auth::ResetPassword do
  let!(:user) do
    User.create!(
      username: "resetuser",
      email: "reset@test.com",
      password: "oldpassword",
      password_confirmation: "oldpassword",
      reset_password_token: "validtoken",
      reset_password_sent_at: 1.hour.ago
    )
  end

  it "resets the password with a valid token" do
    described_class.call(token: "validtoken", password: "newpassword")

    user.reload
    expect(user.authenticate("newpassword")).to be_truthy
    expect(user.reset_password_token).to be_nil
  end

  it "fails with invalid token" do
    result = described_class.call(token: "badtoken", password: "newpassword")

    expect(result).to be_nil
  end
end
