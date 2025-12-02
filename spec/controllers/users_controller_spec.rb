# spec/controllers/users_controller_spec.rb
require "rails_helper"

RSpec.describe UsersController, type: :controller do
  let!(:user) do
    User.create!(
      username: "john",
      email: "john@example.com",
      password: "password",
      password_confirmation: "password"
    )
  end

  let!(:other_user) do
    User.create!(
      username: "mary",
      email: "mary@example.com",
      password: "password",
      password_confirmation: "password"
    )
  end

  def log_in(u)
    session[:user_id] = u.id
  end

  describe "GET #show" do
    it "loads the user and their pins, reposts and tagged pins" do
      pin = user.pins.create!(title: "Sample", description: "Test")
      tagged_pin = Pin.create!(title: "Tagged", description: "Test", user: other_user)
      PinTag.create!(pin: tagged_pin, tagged_user: user)

      get :show, params: { id: user.id }

      loaded_user = controller.instance_variable_get(:@user)
      pins        = controller.instance_variable_get(:@pins)
      tagged      = controller.instance_variable_get(:@tagged_pins)

      expect(loaded_user).to eq(user)
      expect(pins).to include(pin)
      expect(tagged).to include(tagged_pin)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #tagged" do
    it "loads all pins where the user is tagged" do
      pin = Pin.create!(title: "Tagged", description: "Test", user: other_user)
      PinTag.create!(pin: pin, tagged_user: user)

      get :tagged, params: { id: user.id }

      pins = controller.instance_variable_get(:@pins)
      expect(pins).to include(pin)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #new" do
    it "initializes a new user" do
      get :new
      new_user = controller.instance_variable_get(:@user)
      expect(new_user).to be_a_new(User)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST #create" do
    context "valid params" do
      it "creates a user and logs them in" do
        expect {
          post :create, params: {
            user: {
              username: "newbie",
              email: "newbie@example.com",
              password: "password",
              password_confirmation: "password"
            }
          }
        }.to change(User, :count).by(1)

        expect(session[:user_id]).to eq(User.last.id)
        expect(response).to redirect_to(pins_path)
      end
    end

    context "invalid params" do
      it "re-renders new with errors" do
        post :create, params: {
          user: {
            username: "",
            email: "bad-email",
            password: "x",
            password_confirmation: "y"
          }
        }

        u = controller.instance_variable_get(:@user)
        expect(u.errors).not_to be_empty
        expect(response.status).to eq(422)
      end
    end
  end

  describe "GET #edit" do
    context "valid user" do
      it "renders edit" do
        log_in(user)
        get :edit, params: { id: user.id }
        expect(response).to have_http_status(:ok)
      end
    end

    context "other user" do
      it "redirects unauthorized user" do
        log_in(other_user)
        get :edit, params: { id: user.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You can only edit your own profile.")
      end
    end
  end

  describe "PATCH #update" do
    before { log_in(user) }

    context "valid update" do
      it "updates the user" do
        patch :update, params: { id: user.id, user: { username: "updated" } }
        expect(user.reload.username).to eq("updated")
        expect(response).to redirect_to(user_path(user))
      end
    end

    context "invalid update" do
      it "does not update and re-renders edit" do
        original_email = user.email

        patch :update, params: {
          id: user.id,
          user: { email: "invalid" }
        }

        u = controller.instance_variable_get(:@user)

        expect(user.reload.email).to eq(original_email)
        expect(u.errors).not_to be_empty
        expect([422, 302]).to include(response.status)
      end
    end
  end

  describe "DELETE #destroy" do
    before { log_in(user) }

    it "deletes the account" do
      expect {
        delete :destroy, params: { id: user.id }
      }.to change(User, :count).by(-1)

      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(root_path)
    end
  end
end

