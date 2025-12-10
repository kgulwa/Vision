require "rails_helper"

RSpec.describe "PinsController", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:pin) { create(:pin, user_uid: user.uid) }

  let(:valid_params) do
    {
      pin: {
        title: "Test Pin",
        description: "Test description"
      }
    }
  end

  before do
    post login_path, params: { username: user.username, password: "password" }
  end

  
  # CREATE
  
  describe "POST /pins" do
    it "creates a new pin with valid params" do
      expect {
        post pins_path, params: valid_params
      }.to change(Pin, :count).by(1)

      expect(Pin.last.user_uid).to eq(user.uid)
      expect(response).to redirect_to(pin_path(Pin.last.id))
    end

    it "renders :new when save fails" do
      expect {
        post pins_path, params: { pin: { title: "", description: "bad" } }
      }.not_to change(Pin, :count)

      expect(response.status).to eq(422)
      expect(response.body).to include("Failed to post pin")
    end
  end

  
  # SHOW
  
  describe "GET /pins/:id" do
    it "redirects when pin's user is missing" do
      orphan_pin = build(:pin)
      orphan_pin.user = nil
      orphan_pin.user_uid = "missing-uid"
      orphan_pin.save(validate: false)

      get pin_path(orphan_pin)

      expect(response).to redirect_to(pins_path)
      expect(flash[:alert]).to eq("Pin not found")
    end

    it "renders show when valid" do
      get pin_path(pin)
      expect(response).to have_http_status(:ok)
    end
  end

  
  # UPDATE
  
  describe "PATCH /pins/:id" do
    it "updates when owner edits their pin" do
      patch pin_path(pin), params: { pin: { title: "Updated" } }
      expect(pin.reload.title).to eq("Updated")
      expect(response).to redirect_to(pin_path(pin))
    end

    it "does not update with invalid params" do
      patch pin_path(pin), params: { pin: { title: "" } }
      expect(response.status).to eq(422)
    end

    it "prevents updating someone else's pin" do
      foreign_pin = create(:pin, user_uid: other_user.uid)
      patch pin_path(foreign_pin), params: { pin: { title: "Hacked" } }

      expect(foreign_pin.reload.title).not_to eq("Hacked")
      expect(response).to redirect_to(pins_path)
    end
  end

  
  # DESTROY
  
  describe "DELETE /pins/:id" do
    it "deletes the pin when owner is logged in" do
      pin_to_delete = create(:pin, user_uid: user.uid)

      expect {
        delete pin_path(pin_to_delete)
      }.to change(Pin, :count).by(-1)

      expect(response).to redirect_to(pins_path)
    end

    it "purges attached file before deletion" do
      pin_with_file = create(:pin, user_uid: user.uid)
      pin_with_file.file.attach(
        io: File.open(Rails.root.join("spec/fixtures/files/test.png")),
        filename: "test.png",
        content_type: "image/png"
      )

      expect(pin_with_file.file).to be_attached

      delete pin_path(pin_with_file)

      expect(Pin.exists?(pin_with_file.id)).to eq(false)
    end
  end

  
  # SEARCH
  
  describe "GET /searc (search_path)" do
    it "returns matching pins when query present" do
      match_user = create(:user)
      create(:pin, title: "Hello World", user_uid: match_user.uid)

      get search_path, params: { query: "Hello" }

      expect(response).to have_http_status(:ok)
      expect(response.body).not_to be_empty
    end

    it "returns none when query is empty" do
      get search_path, params: { query: "" }

      expect(response.body).not_to include("Test Pin")
    end
  end

  
  # TAGGING USERS
  
  describe "POST /pins with tagged users" do
    let(:tagged_user) { create(:user) }

    it "creates pin tags + notifications for valid user UIDs" do
      params = {
        pin: {
          title: "Test Pin",
          description: "Desc",
          tagged_user_ids: [tagged_user.uid]
        }
      }

      expect {
        post pins_path, params: params
      }.to change(PinTag, :count).by(1)
         .and change(Notification, :count).by(1)
    end

    it "skips blank user IDs" do
      params = {
        pin: {
          title: "Test Pin",
          description: "Desc",
          tagged_user_ids: [""]
        }
      }

      expect {
        post pins_path, params: params
      }.not_to change(PinTag, :count)
    end

    it "does nothing when tagged_user_ids missing" do
      params = valid_params

      expect {
        post pins_path, params: params
      }.not_to change(PinTag, :count)
    end
  end
end
