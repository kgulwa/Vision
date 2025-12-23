require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "POST /users" do
    context "with valid parameters" do
      it "creates a user and redirects to login" do
        expect {
          post users_path, params: {
            user: {
              username: "newuser",
              email: "new@example.com",
              password: "password123",
              password_confirmation: "password123"
            }
          }
        }.to change(User, :count).by(1)

        #  User is NOT auto-logged in anymore
        expect(response).to redirect_to(login_path)
      end
    end

    context "with duplicate email" do
      it "renders error" do
        User.create!(
          username: "existing",
          email: "test@example.com",
          password: "password123",
          password_confirmation: "password123"
        )

        post users_path, params: {
          user: {
            username: "new",
            email: "test@example.com",
            password: "password123",
            password_confirmation: "password123"
          }
        }

        expect(response.status).to eq(422)
        expect(response.body).to include("Email has already been taken")
      end
    end
  end
end
