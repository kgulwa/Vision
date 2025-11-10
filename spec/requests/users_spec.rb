require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "POST /users" do
    context "with valid parameters" do
      it "creates a new user and logs them in" do
        user_params = {
          user: {
            username: 'newuser',
            email: 'newuser@example.com',
            password: 'password123',
            password_confirmation: 'password123'
          }
        }

        expect {
          post users_path, params: user_params
        }.to change(User, :count).by(1)

        expect(response).to redirect_to(root_path)
        expect(session[:user_id]).to eq(User.last.id)
      end
    end

    context "with duplicate email" do
      it "does not create a user and shows error" do
        existing_user = User.create!(
          username: 'existing',
          email: 'test@example.com',
          password: 'password123'
        )

        user_params = {
          user: {
            username: 'newuser',
            email: 'test@example.com',
            password: 'password123',
            password_confirmation: 'password123'
          }
        }

        expect {
          post users_path, params: user_params
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("Email has already been taken")
      end
    end

    context "with mismatched passwords" do
      it "does not create a user and shows error" do
        user_params = {
          user: {
            username: 'newuser',
            email: 'newuser@example.com',
            password: 'password123',
            password_confirmation: 'different123'
          }
        }

        expect {
          post users_path, params: user_params
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("Password confirmation doesn&#39;t match Password")
      end
    end

    context "with invalid email format" do
      it "does not create a user and shows error" do
        user_params = {
          user: {
            username: 'newuser',
            email: 'invalid_email',
            password: 'password123',
            password_confirmation: 'password123'
          }
        }

        expect {
          post users_path, params: user_params
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("Email is invalid")
      end
    end
  end
end