require "rails_helper"

RSpec.describe Likes::Create do
  let(:user) { create(:user) }
  let(:pin_owner) { create(:user) }
  let(:pin) { create(:pin, user: pin_owner) }

  subject { described_class.call(user: user, pin: pin) }

  describe ".call" do
    it "likes the pin" do
      expect(user).to receive(:like).with(pin)
      subject
    end
  end

  describe "notifications" do
    context "when liking someone else's pin" do
      it "creates a notification for the pin owner" do
        expect {
          subject
        }.to change(Notification, :count).by(1)

        notification = Notification.last
        expect(notification.user).to eq(pin_owner)
        expect(notification.actor).to eq(user)
        expect(notification.action).to eq("liked your post")
      end
    end

    context "when liking your own pin" do
      let(:pin_owner) { user }

      it "does not notify yourself" do
        expect {
          subject
        }.not_to change(Notification, :count)
      end
    end

    context "when pin has tagged users" do
      let(:tagged_user) { create(:user) }

      before do
        allow(pin).to receive(:tagged_users).and_return([tagged_user])
      end

      it "notifies tagged users" do
        expect {
          subject
        }.to change(Notification, :count).by(2) # owner + tagged
      end
    end

    context "when user is tagged on their own like" do
      before do
        allow(pin).to receive(:tagged_users).and_return([user])
      end

      it "does not notify the liking user" do
        expect {
          subject
        }.to change(Notification, :count).by(1) # owner only
      end
    end
  end
end
