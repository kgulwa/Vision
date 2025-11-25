require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:pin) { create(:pin, user: user) }

  describe "likes" do
    it "likes a pin via Like model" do
      Like.create!(user: user, pin: pin)
      expect(user.likes.exists?(pin_id: pin.id)).to be true
    end

    it "unlikes a pin via Like model" do
      like = Like.create!(user: user, pin: pin)
      like.destroy
      expect(user.likes.exists?(pin_id: pin.id)).to be false
    end
  end

  describe "reposts" do
    it "reposts a pin via Repost model" do
      Repost.create!(user: user, pin: pin)
      expect(user.reposts.exists?(pin_id: pin.id)).to be true
    end

    it "unreposts a pin via Repost model" do
      repost = Repost.create!(user: user, pin: pin)
      repost.destroy
      expect(user.reposts.exists?(pin_id: pin.id)).to be false
    end
  end

  describe "saved pins" do
    let(:collection) { create(:collection, user: user) }

    it "saves a pin via SavedPin model" do
      SavedPin.create!(user: user, pin: pin, collection: collection)
      expect(user.saved_pins.exists?(pin_id: pin.id)).to be true
    end

    it "unsaves a pin via SavedPin model" do
      saved = SavedPin.create!(user: user, pin: pin, collection: collection)
      saved.destroy
      expect(user.saved_pins.exists?(pin_id: pin.id)).to be false
    end
  end
end
