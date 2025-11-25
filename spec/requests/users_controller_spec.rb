require "rails_helper"

RSpec.describe "UsersController", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe "GET /users/:id/edit" do
    it "redirects if not logged in" do
      get edit_user_path(user.id)
      expect(response).to redirect_to(root_path)
    end
  end

  describe "PATCH /users/:id" do
    before do
      post login_path, params: {
        username: user.username,
        password: "password"
      }
      expect(session[:user_id]).to eq(user.id)
    end

    it "updates the profile when logged in" do
      patch user_path(user.id), params: {
        user: { username: "newname" }
      }

      expect(response).to redirect_to(user_path(user.id))
      expect(user.reload.username).to eq("newname")
    end

    it "does not allow updating another user's profile" do
      patch user_path(other_user.id), params: {
        user: { username: "hacked" }
      }

      expect(other_user.reload.username).not_to eq("hacked")
      expect(response).to redirect_to(root_path)
    end
  end

  describe "DELETE /users/:id" do
    before do
      post login_path, params: {
        username: user.username,
        password: "password"
      }
    end

    it "deletes the account when logged in" do
      expect {
        delete user_path(user.id)
      }.to change(User, :count).by(-1)

      expect(response).to redirect_to(root_path)
    end
  end
end
