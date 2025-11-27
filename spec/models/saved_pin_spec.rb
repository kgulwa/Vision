require "rails_helper"

RSpec.describe SavedPin, type: :model do
  let(:user) do
    User.create!(
      username: "tester",
      email: "test@example.com",
      password: "password",
      password_confirmation: "password"
    )
  end

  let(:pin) do
    Pin.create!(
      title: "Test Pin",
      description: "A pin",
      user: user
    )
  end

  let(:collection) do
    Collection.create!(
      name: "My Collection",
      user: user
    )
  end

  describe "associations" do
    it "belongs to a pin" do
      assoc = SavedPin.reflect_on_association(:pin)
      expect(assoc.macro).to eq(:belongs_to)
    end

    it "belongs to a collection" do
      assoc = SavedPin.reflect_on_association(:collection)
      expect(assoc.macro).to eq(:belongs_to)
    end

    it "belongs to a user" do
      assoc = SavedPin.reflect_on_association(:user)
      expect(assoc.macro).to eq(:belongs_to)
    end
  end

  describe "validations" do
    it "is valid with all required fields" do
      saved_pin = SavedPin.new(pin: pin, collection: collection, user: user)
      expect(saved_pin).to be_valid
    end

    it "validates uniqueness of pin_id scoped to collection_id" do
      SavedPin.create!(pin: pin, collection: collection, user: user)

      dup = SavedPin.new(pin: pin, collection: collection, user: user)
      expect(dup).not_to be_valid
      expect(dup.errors[:pin_id]).to include("has already been taken")
    end
  end
end
