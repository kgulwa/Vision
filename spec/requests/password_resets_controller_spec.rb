# spec/requests/password_resets_controller_spec.rb
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

  describe "GET /forgot_password" do
    it "renders the forgot password page" do
      get forgot_password_path
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:new)
    end
  end

  describe "POST /forgot_password" do
    context "with valid email" do
      it "redirects to login with notice" do
        post forgot_password_path, params: { email: user.email }
        expect(response).to redirect_to(login_path)
        expect(flash[:notice]).to eq(
          "If that email exists, a reset link has been sent."
        )
      end
    end

    context "with invalid email" do
      before do
        allow(Auth::SendPasswordReset).to receive(:call).and_return(false)
      end

      it "renders new with alert" do
        post forgot_password_path, params: { email: "invalid@test.com" }
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash[:alert]).to eq("Unable to send reset email")
      end
    end
  end

  describe "GET /reset_password" do
    context "with valid token" do
      it "renders the reset password page" do
        user.update!(
          reset_password_token: "token123",
          reset_password_sent_at: Time.current
        )

        get reset_password_path(token: "token123")

        expect(response).to have_http_status(:success)
        expect(response).to render_template(:edit)
      end
    end

    context "with invalid token" do
      it "renders the reset password page" do
        get reset_password_path(token: "invalidtoken")

        expect(response).to render_template(:edit)
        expect(response.body).to include("Reset your password")
      end
    end
  end

  describe "PATCH /reset_password" do
    context "with valid token and password" do
      before do
        user.update!(
          reset_password_token: "token123",
          reset_password_sent_at: Time.current
        )
        allow(Auth::ResetPassword).to receive(:call).and_return(true)
      end

      it "redirects to login with notice" do
        patch reset_password_path(token: "token123"),
          params: {
            password: "newpassword",
            password_confirmation: "newpassword"
          }

        expect(response).to redirect_to(login_path)
        expect(flash[:notice]).to eq(
          "Your password has been reset. Please log in."
        )
      end
    end

    context "with invalid token or password" do
      before do
        allow(Auth::ResetPassword).to receive(:call).and_return(false)
      end

      it "renders edit with error state" do
        patch reset_password_path(token: "invalidtoken"),
          params: {
            password: "newpassword",
            password_confirmation: "newpassword"
          }

        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Reset your password")
      end
    end
  end
end
