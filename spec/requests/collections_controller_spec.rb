require "rails_helper"

RSpec.describe "CollectionsController", type: :request do
  let(:user) { create(:user, password: "password123", password_confirmation: "password123") }
  let(:collection) { create(:collection, user: user) }
  let(:pin) { create(:pin, user: user) }

  before do
    request_log_in(user)
  end

  
  # CREATE
  describe "POST /collections" do
    it "creates a new collection" do
      expect {
        post collections_path, params: { name: "New Collection" }
      }.to change(Collection, :count).by(1)

      expect(response).to redirect_to(collection_path(Collection.last.id))
    end

    it "creates a collection AND saves a pin when pin_id is passed" do
      expect {
        post collections_path, params: { name: "Photos", pin_id: pin.id }
      }.to change(Collection, :count).by(1)
       .and change(SavedPin, :count).by(1)

      saved_pin = SavedPin.last
      expect(saved_pin.pin_id).to eq(pin.id)
    end
  end

  
  # SHOW
  describe "GET /collections/:id" do
    it "renders the show page and displays saved pins" do
      sp = SavedPin.create!(user: user, pin: pin, collection: collection)

      get collection_path(collection)
      expect(response).to have_http_status(:ok)

      # Check rendered output instead of assigns
      expect(response.body).to include(sp.pin.title)
    end
  end

  # EDIT
  
  describe "GET /collections/:id/edit" do
    it "renders edit" do
      get edit_collection_path(collection)
      expect(response).to have_http_status(:ok)
    end
  end

  
  # UPDATE
  
  describe "PATCH /collections/:id" do
    it "updates name successfully" do
      patch collection_path(collection), params: {
        collection: { name: "Updated Name" }
      }

      expect(collection.reload.name).to eq("Updated Name")
      expect(response).to redirect_to(collection_path(collection))
    end

    it "renders edit on failure" do
      patch collection_path(collection), params: {
        collection: { name: "" }
      }

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  
  # SAVED INDEX
  
  describe "GET /saved" do
    it "loads the saved collections page" do
      get saved_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Your Saved Collections")
    end
  end

  
  # DESTROY
  
  describe "DELETE /collections/:id" do
    it "deletes the user's own collection" do
      col = create(:collection, user: user)

      expect {
        delete collection_path(col)
      }.to change(Collection, :count).by(-1)

      expect(response).to redirect_to(saved_path)
    end

    it "does NOT delete another user's collection" do
      other_user = create(:user, password: "password123", password_confirmation: "password123")
      other_collection = create(:collection, user: other_user)

      delete collection_path(other_collection)

      expect(response).to redirect_to(saved_path)
      expect(Collection.exists?(other_collection.id)).to eq(true)
    end
  end

  
  # REMOVE PIN 
  
  describe "DELETE /collections/:collection_id/remove_pin/:saved_pin_id" do
    let!(:saved_pin) { SavedPin.create!(user: user, pin: pin, collection: collection) }

    it "removes a pin from the collection" do
      expect {
        delete collection_remove_pin_path(collection.id, saved_pin.id)
      }.to change(SavedPin, :count).by(-1)

      expect(response).to redirect_to(collection_path(collection))
    end

    it "does nothing if saved_pin does not exist" do
      expect {
        delete collection_remove_pin_path(collection.id, 99999)
      }.not_to change(SavedPin, :count)

      expect(response).to redirect_to(collection_path(collection))
    end
  end

  
  # SET COLLECTION FAIL CASE
  
  describe "set_collection before_action" do
    it "redirects when collection does not belong to current_user" do
      other_user = create(:user)
      other_collection = create(:collection, user: other_user)

      get collection_path(other_collection.id)

      expect(response).to redirect_to(saved_path)
      expect(flash[:alert]).to eq("Collection not found")
    end
  end
end
