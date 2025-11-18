require 'rails_helper'

RSpec.describe "Follows", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before do
    # Log in
    post login_path, params: { username: user.username, password: 'password123' }
  end

  describe "POST /users/:user_id/follow" do
    it "follows another user" do
      expect {
        post user_follow_path(other_user)
      }.to change(Follow, :count).by(1)

      expect(response).to redirect_to(user_path(other_user))
      follow_redirect!
      expect(response.body).to include("You are now following #{other_user.username}!")
    end
  end

  describe "DELETE /users/:user_id/follow" do
    before do
      user.follow(other_user)
    end

    it "unfollows a user" do
      expect {
        delete user_follow_path(other_user)
      }.to change(Follow, :count).by(-1)

      expect(response).to redirect_to(user_path(other_user))
      follow_redirect!
      expect(response.body).to include("You unfollowed #{other_user.username}.")
    end
  end

  describe "requires login" do
    it "redirects to login if not logged in" do
      delete logout_path
      post user_follow_path(other_user)
      expect(response).to redirect_to(login_path)
      follow_redirect!
      expect(response.body).to include("You must be logged in to follow users.")
    end
  end
end
