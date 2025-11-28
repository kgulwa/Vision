require "rails_helper"

RSpec.describe MentionsController, type: :controller do
  before do
    @user = User.create!(
      username: "kate",
      email: "kate@example.com",
      password: "password",
      password_confirmation: "password"
    )
    session[:user_id] = @user.id
  end

  it "returns users matching the query" do
    User.create!(
      username: "katy",
      email: "katy@example.com",
      password: "password",
      password_confirmation: "password"
    )

    get :index, params: { q: "ka" }

    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body).to be_an(Array)
  end
end
