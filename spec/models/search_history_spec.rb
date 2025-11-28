require "rails_helper"

RSpec.describe SearchHistory, type: :model do
  let(:user) do
    User.create!(
      username: "searcher",
      email: "s@example.com",
      password: "password",
      password_confirmation: "password"
    )
  end

  it "is valid with a query" do
    record = SearchHistory.new(user: user, query: "cats")
    expect(record).to be_valid
  end

  it "is invalid without a query" do
    record = SearchHistory.new(user: user, query: nil)
    expect(record).not_to be_valid
  end
end
