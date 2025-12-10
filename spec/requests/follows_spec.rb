require "rails_helper"

RSpec.describe "Follows", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before do
    # Test helper that logs in using UID and stubs current_user
    log_in_as(user)
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
