require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:pin) { create(:pin, user_uid: user.uid) }

  describe "likes" do
    it "likes a pin" do
      user.like(pin)
      expect(user.liked?(pin)).to be true
    end

    it "unlikes a pin" do
      user.like(pin)
      user.unlike(pin)
      expect(user.liked?(pin)).to be false
    end
  end

  describe "reposts" do
    it "reposts a pin" do
      user.repost(pin)
      expect(user.reposted?(pin)).to be true
    end

    it "unreposts a pin" do
      user.repost(pin)
      user.unrepost(pin)
      expect(user.reposted?(pin)).to be false
    end
  end

  describe "saved pins" do
    it "saves a pin" do
      user.save_pin(pin)
      expect(user.saved?(pin)).to be true
    end

    it "unsaves a pin" do
      user.save_pin(pin)
      user.unsave(pin)
      expect(user.saved?(pin)).to be false
    end
  end
end
