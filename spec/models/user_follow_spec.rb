require 'rails_helper'

RSpec.describe User, type: :model do
  describe "following functionality" do
    let(:user) do
      User.create!(
        username: "userA",
        email: "a@example.com",
        password: "password",
        password_confirmation: "password"
      )
    end

    let(:other_user) do
      User.create!(
        username: "userB",
        email: "b@example.com",
        password: "password",
        password_confirmation: "password"
      )
    end

    it "can follow another user" do
      expect(user.following?(other_user)).to be false
      user.follow(other_user)
      expect(user.following?(other_user)).to be true
      expect(other_user.followers).to include(user)
    end

    it "cannot follow the same user twice" do
      user.follow(other_user)
      expect { user.follow(other_user) }.not_to change { user.followings.count }
    end

    it "cannot follow themselves" do
      expect { user.follow(user) }.not_to change { user.followings.count }
    end

    it "can unfollow a user" do
      user.follow(other_user)
      user.unfollow(other_user)
      expect(user.following?(other_user)).to be false
    end
  end
end
