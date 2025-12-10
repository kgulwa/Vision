require "rails_helper"

RSpec.describe FollowsController, type: :controller do
  let(:user)        { create(:user) }
  let(:other_user)  { create(:user) }

  before do
    # Your app uses session for login, NOT Devise
    session[:user_id] = user.uid
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
