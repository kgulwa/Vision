require "rails_helper"

RSpec.describe UserProfile do
  let(:user) { create(:user) }
  let(:profile) { described_class.new(user) }

  describe "#initialize" do
    it "stores the user" do
      expect(profile.user).to eq(user)
    end
  end

  describe "#pins" do
    it "returns the user's pins ordered by newest first" do
      older_pin = create(:pin, user: user, created_at: 2.days.ago)
      newer_pin = create(:pin, user: user, created_at: 1.hour.ago)

      expect(profile.pins).to eq([newer_pin, older_pin])
    end
  end

  describe "#reposted_pins" do
    it "returns the user's reposted pins ordered by newest first" do
      older_pin = create(:pin, created_at: 3.days.ago)
      newer_pin = create(:pin, created_at: 1.day.ago)

      create(:repost, user: user, pin: older_pin, created_at: 2.days.ago)
      create(:repost, user: user, pin: newer_pin, created_at: 1.hour.ago)

      expect(profile.reposted_pins).to eq([newer_pin, older_pin])
    end
  end

  describe "#collections" do
    it "returns the user's collections" do
      collection1 = create(:collection, user: user)
      collection2 = create(:collection, user: user)

      expect(profile.collections).to match_array([collection1, collection2])
    end
  end

  describe "#tagged_pins" do
    it "returns tagged pins ordered by newest first" do
      pin1 = create(:pin, created_at: 2.days.ago)
      pin2 = create(:pin, created_at: 1.hour.ago)

      create(:pin_tag, pin: pin1, tagged_user: user, tagged_by: user, created_at: 2.days.ago)
      create(:pin_tag, pin: pin2, tagged_user: user, tagged_by: user, created_at: 1.hour.ago)

      result = profile.tagged_pins

      expect(result).to eq([pin2, pin1])
      expect(result).to all(be_a(Pin))
    end
  end
end
