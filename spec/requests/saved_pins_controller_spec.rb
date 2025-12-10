require "rails_helper"

RSpec.describe "SavedPinsController", type: :request do
  let(:user) do
    create(:user,
      password: "password123",
      password_confirmation: "password123"
    )
  end

  let(:pin_owner) { create(:user) }
  let(:pin)       { create(:pin, user: pin_owner) }  # FIXED: correct association handling

  before do
    request_log_in(user)
  end

  describe "POST /pins/:pin_id/saved_pins" do
    context "when saving into an existing collection" do
      let!(:collection) { create(:collection, user: user, name: "My Stuff") }

      it "saves the pin into the given collection" do
        expect {
          post pin_saved_pins_path(pin), params: { collection_id: collection.id }
        }.to change(SavedPin, :count).by(1)

        saved = SavedPin.last
        expect(saved.pin_id).to eq(pin.id)
        expect(saved.collection_id).to eq(collection.id)
        expect(saved.user_id).to eq(user.id)
      end
    end

    context "when creating a new collection by name" do
      it "creates the collection and saves the pin there" do
        expect {
          post pin_saved_pins_path(pin), params: { new_collection_name: "Travel" }
        }.to change(Collection, :count).by(1)
         .and change(SavedPin, :count).by(1)

        expect(Collection.last.name).to eq("Travel")
      end
    end

    context "when neither collection_id nor new_collection_name is provided" do
      it "creates or finds the Default collection" do
        expect {
          post pin_saved_pins_path(pin)
        }.to change(SavedPin, :count).by(1)

        expect(Collection.last.name).to eq("Default")
      end
    end

    context "when saving the same pin twice" do
      it "does NOT duplicate the SavedPin" do
        post pin_saved_pins_path(pin)
        expect {
          post pin_saved_pins_path(pin)
        }.not_to change(SavedPin, :count)
      end
    end

    context "notifications" do
      it "creates a notification for the pin owner" do
        expect {
          post pin_saved_pins_path(pin)
        }.to change(Notification, :count).by(1)

        notif = Notification.last
        expect(notif.user).to eq(pin_owner)
        expect(notif.actor).to eq(user)
        expect(notif.action).to eq("saved your post")
      end

      it "does NOT notify when the user saves their own pin" do
        pin.update!(user_uid: user.uid)

        expect {
          post pin_saved_pins_path(pin)
        }.not_to change(Notification, :count)
      end
    end
  end

  describe "DELETE /pins/:pin_id/saved_pins/:id" do
    let!(:collection) { create(:collection, user: user) }
    let!(:saved_pin)  { create(:saved_pin, user: user, pin: pin, collection: collection) }

    it "removes the saved pin" do
      expect {
        delete pin_saved_pin_path(pin, saved_pin)
      }.to change(SavedPin, :count).by(-1)
    end

    it "redirects back to the pin page" do
      delete pin_saved_pin_path(pin, saved_pin)
      expect(response).to redirect_to(pin_path(pin.id))
    end
  end

  describe "POST /pins/:pin_id/saved_pins when pin does not exist" do
    it "redirects to pins_path with an alert" do
      expect {
        post pin_saved_pins_path(-999)
      }.not_to change(SavedPin, :count)

      expect(response).to redirect_to(pins_path)

      follow_redirect!
      expect(response.body).to include("Pin not found")
    end
  end
end
