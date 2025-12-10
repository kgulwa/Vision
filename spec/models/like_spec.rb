require "rails_helper"

RSpec.describe Like, type: :model do
  let(:user) { create(:user) }
  let(:pin)  { create(:pin, user_uid: user.uid) }

  it "is valid with user and pin" do
    like = Like.new(user: user, pin: pin)
    expect(like).to be_valid
  end

  it "requires a user" do
    like = Like.new(pin: pin)
    expect(like).not_to be_valid
  end
end
