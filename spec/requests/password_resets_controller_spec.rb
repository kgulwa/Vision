require "rails_helper"

RSpec.describe "PasswordResets", type: :request do
  let!(:user) do
    User.create!(
      username: "controlleruser",
      email: "controller@test.com",
      password: "password",
      password_confirmation: "password"
    )
  end

  it "renders forgot password page" do
    get forgot_password_path
    expect(response).to have_http_status(:success)
  end

  it "creates a password reset request" do
    post forgot_password_path, params: { email: user.email }
    expect(response).to redirect_to(login_path)
  end

  it "renders reset password page" do
    user.update!(
      reset_password_token: "token123",
      reset_password_sent_at: Time.current
    )

    get reset_password_path(token: "token123")
    expect(response).to have_http_status(:success)
  end
end
