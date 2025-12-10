require 'rails_helper'

RSpec.describe SavedPinsController, type: :controller do
  let(:user) { create(:user) }
  let(:pin_owner) { create(:user) }
  let(:pin) { create(:pin, user: pin_owner) }
  let(:collection) { create(:collection, user: user) }

  before do
    allow(controller).to receive(:require_login).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "POST #create" do
    context "when saving to an existing collection" do
      it "creates a SavedPin and redirects (HTML)" do
        post :create, params: { pin_id: pin.id, collection_id: collection.id }, format: :html

        saved = SavedPin.last
        expect(saved.user).to eq(user)
        expect(saved.pin).to eq(pin)
        expect(saved.collection).to eq(collection)

        expect(response).to redirect_to(pin_path(pin.id))
      end
    end

    context "when saving to a new collection" do
      it "creates the collection and saves the pin" do
        expect {
          post :create, params: { pin_id: pin.id, new_collection_name: "New Stuff" }, format: :html
        }.to change(Collection, :count).by(1)

        expect(Collection.last.name).to eq("New Stuff")
        expect(response).to redirect_to(pin_path(pin.id))
      end
    end

    context "when no collection params are given" do
      it "uses the Default collection" do
        expect {
          post :create, params: { pin_id: pin.id }, format: :html
        }.to change(Collection, :count).by(1)

        expect(Collection.last.name).to eq("Default")
        expect(response).to redirect_to(pin_path(pin.id))
      end
    end

    context "when user saves someone else's pin" do
      it "creates a notification" do
        expect {
          post :create, params: { pin_id: pin.id }, format: :html
        }.to change(Notification, :count).by(1)
      end
    end

    context "when user saves their own pin" do
      before { allow(controller).to receive(:current_user).and_return(pin_owner) }

      it "does NOT create a notification" do
        create(:collection, user: pin_owner)
        expect {
          post :create, params: { pin_id: pin.id }, format: :html
        }.not_to change(Notification, :count)
      end
    end

    context "turbo stream request" do
      it "responds to turbo_stream without error" do
        post :create, params: { pin_id: pin.id, collection_id: collection.id }, format: :turbo_stream

        
        expect(response).to have_http_status(:no_content)

      end
    end
  end

  describe "DELETE #destroy" do
    context "when saved pin exists" do
      it "deletes the saved pin and redirects" do
        saved_pin = create(:saved_pin, user: user, pin: pin, collection: collection)

        expect {
          delete :destroy, params: { id: saved_pin.id, pin_id: pin.id }
        }.to change(SavedPin, :count).by(-1)

        expect(response).to redirect_to(pin_path(pin.id))
      end
    end

    context "when saved pin does NOT exist" do
      it "raises an error when saved pin does not exist" do
        expect {
          delete :destroy, params: { id: 9999, pin_id: pin.id }
        }.to raise_error(NoMethodError)
      end
    end
  end

  describe "before_action :set_pin" do
    it "redirects when pin does not exist" do
      post :create, params: { pin_id: 9999 }
      expect(response).to redirect_to(pins_path)
    end
  end
end
