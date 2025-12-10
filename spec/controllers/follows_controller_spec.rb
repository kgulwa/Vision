require "rails_helper"

RSpec.describe FollowsController, type: :controller do
  let(:user)        { create(:user, password: "password123", password_confirmation: "password123") }
  let(:other_user)  { create(:user, password: "password123", password_confirmation: "password123") }

  before do
    # Controller authentication uses user.id, not UID
    session[:user_id] = user.id
  end

  describe "POST #create" do
    it "follows another user" do
      expect {
        post :create, params: { user_id: other_user.uid }
      }.to change(Follow, :count).by(1)
    end
  end

  describe "DELETE #destroy" do
    it "unfollows a user" do
      user.follow(other_user)

      expect {
        delete :destroy, params: { user_id: other_user.uid }
      }.to change(Follow, :count).by(-1)
    end
  end
end
