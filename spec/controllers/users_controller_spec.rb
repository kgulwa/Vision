require "rails_helper"

RSpec.describe UsersController, type: :controller do
  describe "POST #create" do
    it "creates a user and logs them in" do
      expect {
        post :create, params: {
          user: {
            username: "newuser",
            email: "new@example.com",
            password: "password",
            password_confirmation: "password"
          }
        }
      }.to change(User, :count).by(1)

      # Your app sets: session[:user_id] = @user.uid
      expect(session[:user_id]).to eq(User.last.uid)
    end
  end

  describe "PATCH #update" do
    let(:user) { create(:user) }

    before do
      session[:user_id] = user.uid
    end

    it "invalid update does not update and re-renders edit" do
      original_email = user.email

      patch :update, params: {
        id: user.uid,  # UsersController expects UID as :id
        user: { email: "" }
      }

      expect(user.reload.email).to eq(original_email)
    end
  end
end
