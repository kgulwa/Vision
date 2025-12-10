require "rails_helper"

RSpec.describe "SavedPinsController", type: :request do
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

  describe "POST /pins/:pin_id/saved_pins" do
    it "saves a pin to a new collection" do
      expect {
        post pin_saved_pins_path(pin), params: { new_collection_name: "Favorites" }
      }.to change(SavedPin, :count).by(1)
      expect(response).to redirect_to(pin_path(pin))
    end

    it "does not save the same pin twice in the same collection" do
      collection = user.collections.create!(name: "Favorites")
      SavedPin.create!(
        user: user,
        pin: pin,
        collection: collection
      )
      expect {
        post pin_saved_pins_path(pin), params: { collection_id: collection.id }
      }.not_to change(SavedPin, :count)
    end

    it "redirects to login when not logged in" do
      delete logout_path
      post pin_saved_pins_path(pin), params: { new_collection_name: "Favorites" }
      expect(response).to redirect_to(login_path)
    end
  end

  describe "DELETE /pins/:pin_id/saved_pins/:id" do
    it "removes a saved pin" do
      collection = user.collections.create!(name: "Favorites")
      saved_pin = SavedPin.create!(
        user: user,
        pin: pin,
        collection: collection
      )
      expect {
        delete pin_saved_pin_path(pin, saved_pin)
      }.to change(SavedPin, :count).by(-1)
      expect(response).to redirect_to(pin_path(pin))
    end
  end
end
