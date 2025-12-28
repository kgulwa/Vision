require "rails_helper"

RSpec.describe Reposts::Create, type: :service do
  let(:user)      { create(:user) }
  let(:other_user){ create(:user) }
  let(:pin)       { create(:pin, user: other_user) }

  describe ".call" do
    it "creates a repost for the user" do
      expect {
        Reposts::Create.call(user: user, pin: pin)
      }.to change { user.reposts.count }.by(1)
    end

    it "does not create duplicate reposts" do
      user.reposts.create!(pin: pin)

      expect {
        Reposts::Create.call(user: user, pin: pin)
      }.not_to change { user.reposts.count }
    end

    it "creates a notification for the pin owner if different from the actor" do
      expect {
        Reposts::Create.call(user: user, pin: pin)
      }.to change { Notification.count }.by(1)

      notification = Notification.last
      expect(notification.user).to eq(pin.user)
      expect(notification.actor).to eq(user)
      expect(notification.action).to eq("reposted your post")
      expect(notification.notifiable).to eq(pin)
    end

    it "does not notify the owner if user reposts own pin" do
      own_pin = create(:pin, user: user)

      expect {
        Reposts::Create.call(user: user, pin: own_pin)
      }.not_to change { Notification.count }
    end

    it "creates notifications for tagged users except the actor" do
      tagged_user = create(:user)
      pin.pin_tags.create!(tagged_user: tagged_user)

      expect {
        Reposts::Create.call(user: user, pin: pin)
      }.to change { Notification.where(user: tagged_user).count }.by(1)

      notification = Notification.where(user: tagged_user).last
      expect(notification.action).to eq("reposted a post you're tagged in")
    end

    it "skips notifications for tagged users that are the actor" do
      pin.pin_tags.create!(tagged_user: user)

      expect {
        Reposts::Create.call(user: user, pin: pin)
      }.not_to change { Notification.where(user: user).count }
    end
  end
end
