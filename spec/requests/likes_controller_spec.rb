require "rails_helper"

RSpec.describe "LikesController", type: :request do
  let(:user) { create(:user) }
  let(:pin)  { create(:pin, user_uid: user.uid) }

  before do
    # Log in user
    post login_path, params: {
      username: user.username,
      password: "password"
    }
  end

  describe "POST /pins/:pin_id/like" do
    it "likes a pin" do
      expect {
        post pin_like_path(pin)
      }.to change(Like, :count).by(1)

      expect(response).to redirect_to(pin_path(pin))
    end

    it "does not duplicate likes" do
      post pin_like_path(pin)

      expect {
        post pin_like_path(pin)
      }.not_to change(Like, :count)
    end
  end

  describe "DELETE /pins/:pin_id/like" do
    it "unlikes a pin" do
      Like.create!(pin: pin, user_uid: user.uid)

      expect {
        delete pin_like_path(pin)
      }.to change(Like, :count).by(-1)

      expect(response).to redirect_to(pin_path(pin))
    end
  end
end
