require "rails_helper"

RSpec.describe "CollectionsController", type: :request do
  let(:user) { create(:user) }
  let(:collection) { create(:collection, user: user) }

  before do
    post login_path, params: { username: user.username, password: "password" }
  end

  describe "DELETE /collections/:id" do
    it "does NOT delete collections" do
      expect {
        delete collection_path(collection)
      }.not_to change(Collection, :count)
      expect(response).to redirect_to(pins_path)
    end

    it "prevents another user from deleting the collection" do
      other_user = create(:user)
      post login_path, params: { username: other_user.username, password: "password" }
      delete collection_path(collection)
      expect(response).to redirect_to(pins_path)
    end
  end
end
