require "rails_helper"

RSpec.describe SessionsController, type: :controller do
  describe "GET #home" do
    context "when NOT logged in" do
      it "returns success" do
        get :home
        expect(response).to have_http_status(:ok)
      end
    end

    context "when logged in" do
      let(:user) { create(:user, email_verified: true) }

      before do
        session[:user_id] = user.id
      end

      it "returns success" do
        get :home
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "POST #create" do
    it "logs in with valid credentials when email is verified" do
      user = create(
        :user,
        username: "john",
        password: "password",
        password_confirmation: "password",
        email_verified: true
      )

      post :create, params: {
        username: "john",
        password: "password"
      }

      expect(session[:user_id]).to eq(user.id)
      expect(response).to redirect_to(pins_path)
    end

    it "renders :new with invalid credentials" do
      post :create, params: {
        username: "fake",
        password: "wrong"
      }

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "DELETE #destroy" do
    it "logs out the user" do
      session[:user_id] = SecureRandom.uuid

      delete :destroy

      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(root_path)
    end
  end
end
