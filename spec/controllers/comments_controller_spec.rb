require "rails_helper"

RSpec.describe CommentsController, type: :request do
  let(:user) { create(:user) }
  let(:pin) { create(:pin, user: user) }

  before do
    post login_path, params: { username: user.username, password: "password" }
    follow_redirect!
  end

  describe "POST #create" do
    it "creates a comment" do
      expect {
        post pin_comments_path(pin), params: {
          comment: { content: "Hello", parent_id: nil }
        }
      }.to change(Comment, :count).by(1)
    end

    it "fails to create a comment with invalid params and redirects" do
      expect {
        post pin_comments_path(pin), params: {
          comment: { content: "", parent_id: nil }
        }
      }.not_to change(Comment, :count)

      expect(response).to redirect_to(pin_path(pin))
    end

    it "returns unprocessable entity for turbo stream failure" do
      post pin_comments_path(pin),
           params: { comment: { content: "" } },
           headers: { "Accept" => "text/vnd.turbo-stream.html" }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE #destroy" do
    it "deletes a comment" do
      comment = create(:comment, pin: pin, user: user)

      expect {
        delete pin_comment_path(pin, comment)
      }.to change(Comment, :count).by(-1)
    end
  end

  describe "GET #new" do
    it "renders the new template" do
      get new_pin_comment_path(pin)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #edit" do
    it "renders the edit template" do
      comment = create(:comment, pin: pin, user: user)

      get edit_pin_comment_path(pin, comment)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH #update" do
    it "updates a comment successfully" do
      comment = create(:comment, pin: pin, user: user)

      patch pin_comment_path(pin, comment), params: {
        comment: { content: "Updated" }
      }

      expect(comment.reload.content).to eq("Updated")
      expect(response).to redirect_to(pin_path(pin))
    end

    it "does not update a comment with invalid params (HTML)" do
      comment = create(:comment, pin: pin, user: user)

      patch pin_comment_path(pin, comment), params: {
        comment: { content: "" }
      }

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "does not update a comment with invalid params (Turbo Stream)" do
      comment = create(:comment, pin: pin, user: user)

      patch pin_comment_path(pin, comment),
            params: { comment: { content: "" } },
            headers: { "Accept" => "text/vnd.turbo-stream.html" }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "Authentication" do
    it "allows unauthenticated users and redirects to the pin page" do
      post pin_comments_path(pin), params: {
        comment: { content: "Hello" }
      }

      expect(response).to redirect_to(pin_path(pin))
    end
  end
end
