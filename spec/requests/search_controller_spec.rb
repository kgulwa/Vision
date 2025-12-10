require "rails_helper"

RSpec.describe "SearchController", type: :request do
  let(:user) do
    create(:user,
      username: "searcher",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  before do
    request_log_in(user)
  end

  describe "GET /search/users" do
    let!(:john) { create(:user, username: "john") }
    let!(:jane) { create(:user, username: "jane") }
    let!(:alex) { create(:user, username: "alex") }

    it "returns matching users when a query is present" do
      get user_search_path, params: { query: "ja" }

      expect(response).to have_http_status(:ok)

      
      expect(response.body).to include("jane")
      expect(response.body).not_to include("john")
      expect(response.body).not_to include("alex")
    end

    it "saves a new search history entry" do
      expect {
        get user_search_path, params: { query: "john" }
      }.to change { user.search_histories.count }.by(1)

      history = user.search_histories.last
      expect(history.query).to eq("john")
    end

    it "touches existing search history if it already exists" do
      old = user.search_histories.create!(query: "alex", updated_at: 1.day.ago)

      get user_search_path, params: { query: "alex" }

      expect(old.reload.updated_at).to be > 10.seconds.ago
    end

    it "does NOT save history when query is blank" do
      expect {
        get user_search_path, params: { query: "" }
      }.not_to change(SearchHistory, :count)
    end

    it "returns no users when query is blank" do
      get user_search_path, params: { query: "" }

      expect(response.body).not_to include("john")
      expect(response.body).not_to include("jane")
      expect(response.body).not_to include("alex")
    end

    it "loads the user's recent search history" do
      user.search_histories.create!(query: "a")
      user.search_histories.create!(query: "b")

      get user_search_path, params: { query: "a" }

      # Check rendered HTML
      expect(response.body).to include("a")
      expect(response.body).to include("b")
    end
  end

  describe "DELETE /search/clear_history" do
    before do
      user.search_histories.create!(query: "hello")
      user.search_histories.create!(query: "world")
    end

    it "clears all search history records for the user" do
      expect {
        delete clear_search_history_path
      }.to change { user.search_histories.count }.from(2).to(0)

      expect(response).to redirect_to(user_search_path)
    end
  end
end
