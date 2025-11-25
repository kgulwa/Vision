require "rails_helper"

RSpec.describe "Follows", type: :request do
  let(:user)       { create(:user) }
  let(:other_user) { create(:user) }

  before do
    post login_path,
         params: { username: user.username, password: "password" }
    expect(session[:user_id]).to eq(user.id)
  end

  it "follows another user" do
    expect {
      post user_follow_path(other_user)
    }.to change(Follow, :count).by(1)
  end

  it "unfollows a user" do
    user.follow(other_user)

    expect {
      delete user_follow_path(other_user)
    }.to change(Follow, :count).by(-1)
  end
end
