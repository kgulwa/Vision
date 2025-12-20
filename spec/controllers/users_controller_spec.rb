require "rails_helper"

RSpec.describe UsersController, type: :controller do
  describe "POST #create" do
    it "creates a user but does not log them in until email is verified" do
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

      
      expect(session[:user_id]).to be_nil

      
      expect(User.last.email_verified).to be false
    end
  end
end
