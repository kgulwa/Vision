require "rails_helper"

RSpec.describe "CollectionsController", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before do
    post login_path, params: {
      username: user.username,
      password: "password"
    }
  end

  describe "GET /collections/:id" do
    it "shows the collection" do
      collection = user.collections.create!(name: "My Stuff")

      get collection_path(collection)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("My Stuff")
    end
  end

  describe "POST /collections" do
    it "creates a new collection when logged in" do
      expect {
        post collections_path, params: { name: "Favorites" }
      }.to change(Collection, :count).by(1)

      new_collection = Collection.last
      expect(new_collection.name).to eq("Favorites")
      expect(new_collection.user_uid).to eq(user.uid)
      expect(response).to redirect_to(collection_path(new_collection))
    end

    it "creates a collection and saves a pin inside it when pin_id is provided" do
      pin = create(:pin, user_uid: user.uid)

      expect {
        post collections_path,
          params: { name: "Pinned", pin_id: pin.id }
      }.to change(Collection, :count).by(1)
        .and change(SavedPin, :count).by(1)

      saved_pin = SavedPin.last
      expect(saved_pin.pin_id).to eq(pin.id)
      expect(saved_pin.user_uid).to eq(user.uid)
    end
  end

  describe "DELETE /collections/:id" do
    it "does NOT delete collections because the app does not support deletion" do
      collection = user.collections.create!(name: "To Delete")

      expect {
        delete collection_path(collection)
      }.not_to change(Collection, :count)

      # Your app would either 404 or redirect depending on before_action
      expect(response.status).to be_between(300, 404)
    end

    it "prevents another user from deleting the collection (404)" do
      collection = user.collections.create!(name: "Protected")

      delete logout_path

      post login_path, params: {
        username: other_user.username,
        password: "password"
      }

      expect {
        delete collection_path(collection)
      }.not_to change(Collection, :count)

      # Your controller uses `current_user.collections.find`, so this returns 404
      expect(response.status).to eq(404)
    end
  end
end
