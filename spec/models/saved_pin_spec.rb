require "rails_helper"

RSpec.describe SavedPin, type: :model do
  let(:user) { create(:user) }
  let(:pin)  { create(:pin, user_uid: user.uid) }
  let(:collection) { create(:collection, user_uid: user.uid) }

  it "is valid with pin, collection, and user_uid" do
    saved = SavedPin.new(pin: pin, collection: collection, user_uid: user.uid)
    expect(saved).to be_valid
  end

  it "requires a collection" do
    saved = SavedPin.new(pin: pin, user_uid: user.uid)
    expect(saved).not_to be_valid
  end

  it "requires a pin" do
    saved = SavedPin.new(collection: collection, user_uid: user.uid)
    expect(saved).not_to be_valid
  end
end
