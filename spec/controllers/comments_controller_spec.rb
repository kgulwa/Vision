require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { User.create!(email: "test@example.com", password: "password", username: "testuser") }
  let(:other_user) { User.create!(email: "other@example.com", password: "password", username: "otheruser") }

  # Create a pin without requiring an image
  let(:pin) do
    Pin.new(user: user, title: "Test Pin", description: "A test pin").tap do |p|
      p.save(validate: false)  # skips image presence validation
    end
  end

  describe "POST #create" do
    context "when not logged in" do
      it "redirects to login page" do
        post :create, params: { pin_id: pin.id, comment: { content: "Nice pin!" } }
        expect(response).to redirect_to(login_path)
      end
    end

    context "when logged in" do
      before { allow(controller).to receive(:current_user).and_return(user) }

      it "creates a comment with valid params" do
        expect {
          post :create, params: { pin_id: pin.id, comment: { content: "Nice pin!" } }
        }.to change(Comment, :count).by(1)
        expect(response).to redirect_to(pin)
      end

      it "does not create a comment with invalid params" do
        expect {
          post :create, params: { pin_id: pin.id, comment: { content: "" } }
        }.not_to change(Comment, :count)
        expect(response).to redirect_to(pin)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:comment) { Comment.create!(user: user, pin: pin, content: "A comment") }

    context "when not logged in" do
      it "redirects to login page" do
        delete :destroy, params: { pin_id: pin.id, id: comment.id }
        expect(response).to redirect_to(login_path)
      end
    end

    context "when logged in as owner" do
      before { allow(controller).to receive(:current_user).and_return(user) }

      it "deletes the comment" do
        expect {
          delete :destroy, params: { pin_id: pin.id, id: comment.id }
        }.to change(Comment, :count).by(-1)
        expect(response).to redirect_to(pin)
      end
    end

    context "when logged in as another user" do
      before { allow(controller).to receive(:current_user).and_return(other_user) }

      it "does not delete the comment" do
        expect {
          delete :destroy, params: { pin_id: pin.id, id: comment.id }
        }.not_to change(Comment, :count)
        expect(response).to redirect_to(pin)
      end
    end
  end
end
