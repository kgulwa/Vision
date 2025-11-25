require "rails_helper"

RSpec.describe Repost, type: :model do
  let(:user) { create(:user) }
  let(:pin)  { create(:pin, user: user) }

  it "is valid with user_uid and pin" do
    repost = Repost.new(user: user, pin: pin)
    expect(repost).to be_valid
  end
end
