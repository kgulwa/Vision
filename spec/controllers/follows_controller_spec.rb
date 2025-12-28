require "rails_helper"

RSpec.describe FollowsController, type: :controller do
  let(:user)       { create(:user, password: "password123", password_confirmation: "password123") }
  let(:other_user) { create(:user, password: "password123", password_confirmation: "password123") }

  before do
    session[:user_id] = user.id
  end

  describe "POST #create" do
    it "follows another user (HTML)" do
      expect {
        post :create, params: { user_id: other_user.uid }
      }.to change(Follow, :count).by(1)

      expect(response).to redirect_to(user_path(other_user))
      expect(flash[:notice]).to include("You are now following")
    end

    it "follows another user (Turbo Stream)" do
      post :create,
           params: { user_id: other_user.uid },
           format: :turbo_stream

      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      expect(response.body).to include("turbo-stream")
    end
  end

  describe "DELETE #destroy" do
    before do
      user.follow(other_user)
    end

    it "unfollows a user (HTML)" do
      expect {
        delete :destroy, params: { user_id: other_user.uid }
      }.to change(Follow, :count).by(-1)

      expect(response).to redirect_to(user_path(other_user))
      expect(flash[:notice]).to include("You unfollowed")
    end

    it "unfollows a user (Turbo Stream)" do
      delete :destroy,
             params: { user_id: other_user.uid },
             format: :turbo_stream

      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      expect(response.body).to include("turbo-stream")
    end
  end

  describe "when user does not exist" do
    it "raises ActiveRecord::RecordNotFound" do
      expect {
        post :create, params: { user_id: "non-existent-uid" }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
