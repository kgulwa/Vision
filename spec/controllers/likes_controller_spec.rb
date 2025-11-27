require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  let(:user) { User.create!(email: "test@example.com", username: "testuser", password: "password", password_confirmation: "password") }
  let(:pin)  { Pin.create!(title: "Test Pin", description: "Test pin description", user: user) }

  describe "POST #create" do
    context "when not logged in" do
      it "redirects to login page" do
        post :create, params: { pin_id: pin.id }
        expect(response).to redirect_to(login_path)
      end
    end

    context "when logged in" do
      before { allow(controller).to receive(:current_user).and_return(user) }

      it "likes the pin" do
        expect(user).to receive(:like).with(pin)
        post :create, params: { pin_id: pin.id }
      end
    end
  end

  describe "DELETE #destroy" do
    context "when not logged in" do
      it "redirects to login page" do
        delete :destroy, params: { pin_id: pin.id }
        expect(response).to redirect_to(login_path)
      end
    end

    context "when logged in" do
      before { allow(controller).to receive(:current_user).and_return(user) }

      it "unlikes the pin" do
        expect(user).to receive(:unlike).with(pin)
        delete :destroy, params: { pin_id: pin.id }
      end
    end
  end
end
