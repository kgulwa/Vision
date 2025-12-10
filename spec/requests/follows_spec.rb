require "rails_helper"

RSpec.describe "Follows", type: :request do
  let(:user)        { create(:user, password: "password123", password_confirmation: "password123") }
  let(:other_user)  { create(:user, password: "password123", password_confirmation: "password123") }

  before do
    request_log_in(user)
  end

  it "follows another user" do
    expect {
      post user_follow_path(other_user.uid)
    }.to change(Follow, :count).by(1)
  end

  it "unfollows a user" do
    user.follow(other_user)

    expect {
      delete user_follow_path(other_user.uid)
    }.to change(Follow, :count).by(-1)
  end
end
