require "rails_helper"

RSpec.describe "Insights", type: :request do
  let(:user) do
    User.create!(
      username: "tester",
      email: "test@example.com",
      password: "password",
      password_confirmation: "password",
      uid: "abc123"
    )
  end

  # Fake login helper — works for all Rails auth systems
  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
  end

  it "returns http success for the creator" do
    get insights_user_path(user)
    expect(response).to have_http_status(:success)
  end
end
