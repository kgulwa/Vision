require 'rails_helper'

RSpec.describe FollowsController, type: :controller do
  let(:user) { User.create!(email: "test@example.com", username: "testuser", password: "password", password_confirmation: "password") }
  let(:other_user) { User.create!(email: "other@example.com", username: "otheruser", password: "password", password_confirmation: "password") }

  describe "POST #create" do
    context "when not logged in" do
      it "redirects to login page" do
        post :create, params: { user_id: other_user.id }
        expect(response).to redirect_to(login_path)
      end
    end

    context "when logged in" do
      before { allow(controller).to receive(:current_user).and_return(user) }

      it "follows the user" do
        expect {
          post :create, params: { user_id: other_user.id }
        }.to change { user.followings.include?(other_user) }.from(false).to(true)
      end
    end
  end

  describe "DELETE #destroy" do
    before { user.follow(other_user) }

    context "when not logged in" do
      it "redirects to login page" do
        delete :destroy, params: { user_id: other_user.id }
        expect(response).to redirect_to(login_path)
      end
    end

    context "when logged in" do
      before { allow(controller).to receive(:current_user).and_return(user) }

      it "unfollows the user" do
        expect {
          delete :destroy, params: { user_id: other_user.id }
        }.to change { user.followings.include?(other_user) }.from(true).to(false)
      end
    end
  end
end
