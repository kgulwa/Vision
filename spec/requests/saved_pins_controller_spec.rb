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
  end

  describe "POST /pins/:pin_id/saved_pins" do
    it "saves a pin to a collection" do
      expect {
        post pin_saved_pins_path(pin), params: { new_collection_name: "Favorites" }
      }.to change(SavedPin, :count).by(1)

      expect(response).to redirect_to(pin_path(pin))
    end

    it "does not save the same pin twice" do
      collection = user.collections.create!(name: "Favorites")

      SavedPin.create!(
        user_uid: user.uid,
        pin_id: pin.id,
        collection_id: collection.id
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
        user_uid: user.uid,
        pin_id: pin.id,
        collection_id: collection.id
      )

      expect {
        delete pin_saved_pin_path(pin, saved_pin)
      }.to change(SavedPin, :count).by(-1)

      expect(response).to redirect_to(pin_path(pin))
    end
  end
end
