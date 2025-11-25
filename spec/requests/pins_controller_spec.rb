require "rails_helper"

RSpec.describe "PinsController", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  let(:valid_params) do
    {
      pin: {
        title: "Test Pin",
        description: "Test description"
      }
    }
  end

  before do
    post login_path, params: {
      username: user.username,
      password: "password"
    }
    expect(session[:user_id]).to eq(user.id)
  end

  describe "POST /pins" do
    it "creates a new pin with valid params" do
      expect {
        post pins_path, params: valid_params
      }.to change(Pin, :count).by(1)

      expect(Pin.last.user_id).to eq(user.id)
      expect(response).to redirect_to(pins_path)
    end
  end

  describe "PATCH /pins/:id" do
    it "prevents updating someone else's pin" do
      pin = create(:pin, user: other_user)

      patch pin_path(pin), params: { pin: { title: "Hacked" } }

      expect(pin.reload.title).not_to eq("Hacked")
      expect(response).to redirect_to(pins_path)
      expect(flash[:alert]).to eq("You can only edit your own pins.")
    end
  end

  describe "DELETE /pins/:id" do
    it "deletes a pin when the owner is logged in" do
      pin = create(:pin, user: user)

      expect {
        delete pin_path(pin)
      }.to change(Pin, :count).by(-1)

      expect(response).to redirect_to(pins_path)
    end

    it "does NOT allow another user to delete the pin" do
      pin = create(:pin, user: user)

      delete logout_path

      post login_path, params: {
        username: other_user.username,
        password: "password"
      }
      expect(session[:user_id]).to eq(other_user.id)

      expect {
        delete pin_path(pin)
      }.not_to change(Pin, :count)

      expect(response).to redirect_to(pins_path)
    end
  end
end
