require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe "GET #home" do
    context "when NOT logged in" do
      it "returns success" do
        get :home
        expect(response).to have_http_status(:ok)
      end
    end

    context "when logged in" do
      before do
        @user = User.create!(
          username: "test",
          email: "test@example.com",
          password: "password"
        )
        session[:user_id] = @user.id
      end

      it "returns success" do
        get :home
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "POST #create" do
    it "logs in with valid credentials" do
      user = User.create!(
        username: "john",
        email: "john@example.com",
        password: "password"
      )

      post :create, params: { username: "john", password: "password" }

      expect(session[:user_id]).to eq(user.id)
      expect(response).to redirect_to(root_path)
    end

    it "renders :new with invalid credentials" do
      post :create, params: { username: "fake", password: "wrong" }

      expect(response.status).to eq(422)
    end
  end

  describe "DELETE #destroy" do
    it "logs out the user" do
      session[:user_id] = 123

      delete :destroy

      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(root_path)
    end
  end
end
