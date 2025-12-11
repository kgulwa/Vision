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

  before do
    # Log in the user before requesting insights
    post login_path, params: {
      email: user.email,
      password: "password"
    }
  end

  it "returns http success for the creator" do
    get insights_user_path(user)
    expect(response).to have_http_status(:success)
  end
end
