require 'rails_helper'

RSpec.describe Repost, type: :model do
  it "is valid with a user and pin" do
    user = User.create!(username: "a", email: "a@test.com", password: "password")
    pin = Pin.create!(
        title: "x",
        image: fixture_file_upload(Rails.root.join("spec/fixtures/files/test.png"), "image/png"),
        user: user)



    repost = Repost.new(user: user, pin: pin)
    expect(repost).to be_valid
  end

  it "enforces uniqueness: a user cannot repost the same pin twice" do
    user = User.create!(username: "a", email: "b@test.com", password: "password")
    pin = Pin.create!(
        title: "x",
        image: fixture_file_upload(Rails.root.join("spec/fixtures/files/test.png"), "image/png"),
        user: user)



    Repost.create!(user: user, pin: pin)
    duplicate = Repost.new(user: user, pin: pin)

    expect(duplicate).not_to be_valid
  end
end
