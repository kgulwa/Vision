require "rails_helper"

RSpec.describe "Sessions", type: :request do
  let(:user) do
    create(
      :user,
      username: "testuser",
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123",
      email_verified: true
    )
  end

  describe "POST /login" do
    context "with valid credentials" do
      it "logs in and redirects to pins" do
        post login_path, params: {
          username: user.username,
          password: "password123"
        }

        expect(response).to redirect_to(pins_path)
        expect(session[:user_id]).to eq(user.id)
      end
    end
  end

  describe "DELETE /logout" do
    before do
      post login_path, params: {
        username: user.username,
        password: "password123"
      }
    end

    it "logs out the user and redirects to root_path" do
      delete logout_path

      expect(response).to redirect_to(root_path)
      expect(session[:user_id]).to be_nil
    end
  end
end
