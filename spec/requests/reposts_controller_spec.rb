require "rails_helper"

RSpec.describe "RepostsController", type: :request do
  let(:user)      { create(:user) }
  let(:pin_owner) { create(:user) }
  let(:pin)       { create(:pin, user_uid: pin_owner.uid) }

  before do
    post login_path, params: {
      username: user.username,
      password: "password"
    }
    expect(session[:user_id]).to eq(user.id)
  end

  describe "POST /pins/:pin_id/repost" do
    it "reposts a pin" do
      expect {
        post pin_repost_path(pin)
      }.to change(Repost, :count).by(1)
      expect(response).to redirect_to(pin_path(pin))
    end

    it "does not repost the same pin twice" do
      Repost.create!(pin: pin, user: user)
      expect {
        post pin_repost_path(pin)
      }.not_to change(Repost, :count)
    end
  end

  describe "DELETE /pins/:pin_id/repost" do
    it "removes a repost" do
      Repost.create!(pin: pin, user: user)
      expect {
        delete pin_repost_path(pin)
      }.to change(Repost, :count).by(-1)
      expect(response).to redirect_to(pin_path(pin))
    end
  end
end
