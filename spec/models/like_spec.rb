require "rails_helper"

RSpec.describe Like, type: :model do
  let(:user) { create(:user) }
  let(:pin)  { create(:pin, user_uid: user.uid) }

  it "is valid with user_uid and pin" do
    like = Like.new(user_uid: user.uid, pin: pin)
    expect(like).to be_valid
  end

  it "requires a user_uid" do
    like = Like.new(pin: pin)
    expect(like).not_to be_valid
  end
end
