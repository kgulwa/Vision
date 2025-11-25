require "rails_helper"

RSpec.describe SavedPin, type: :model do
  let(:user) { create(:user) }
  let(:pin)  { create(:pin, user: user) }
  let(:collection) { create(:collection, user: user) }

  it "is valid with pin, collection, and user" do
    saved = SavedPin.new(pin: pin, collection: collection, user: user)
    expect(saved).to be_valid
  end

  it "requires a collection" do
    saved = SavedPin.new(pin: pin, user: user)
    expect(saved).not_to be_valid
  end

  it "requires a pin" do
    saved = SavedPin.new(collection: collection, user: user)
    expect(saved).not_to be_valid
  end
end
