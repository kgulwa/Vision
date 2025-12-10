require "rails_helper"

RSpec.describe "CollectionsController", type: :request do
  let(:user) { create(:user, password: "password123", password_confirmation: "password123") }
  let(:collection) { create(:collection, user: user) }

  before do
    request_log_in(user)
  end

  describe "DELETE /collections/:id" do
    it "does NOT delete collections" do
      expect {
        delete collection_path(collection)
      }.not_to change(Collection, :count)

      expect(response).to redirect_to(saved_path)
    end

    it "prevents another user from deleting the collection" do
      other_user = create(:user, password: "password123", password_confirmation: "password123")
      request_log_in(other_user)

      delete collection_path(collection)

      expect(response).to redirect_to(saved_path)
    end
  end
end
