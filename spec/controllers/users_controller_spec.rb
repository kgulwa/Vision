require "rails_helper"

RSpec.describe UsersController, type: :controller do
  describe "POST #create" do
    it "creates a user and logs them in" do
      expect {
        post :create, params: {
          user: {
            username: "newuser",
            email: "new@example.com",
            password: "password123",
            password_confirmation: "password123"
          }
        }
      }.to change(User, :count).by(1)

      expect(session[:user_id]).to eq(User.last.id)
    end
  end
end
