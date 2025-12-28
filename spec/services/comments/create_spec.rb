require "rails_helper"

RSpec.describe Comments::Create do
  let(:user) { create(:user) }
  let(:pin_owner) { create(:user) }
  let(:pin) { create(:pin, user: pin_owner, user_uid: pin_owner.uid) }

  describe ".call" do
    context "when comment is valid" do
      it "creates a comment" do
        expect {
          described_class.call(
            user: user,
            pin: pin,
            params: { content: "Hello" }
          )
        }.to change(Comment, :count).by(1)
      end

      it "creates a notification for the pin owner" do
        expect {
          described_class.call(
            user: user,
            pin: pin,
            params: { content: "Hello" }
          )
        }.to change(Notification, :count).by(1)

        notification = Notification.last
        expect(notification.user).to eq(pin_owner)
        expect(notification.actor).to eq(user)
        expect(notification.action).to eq("commented on your post")
      end
    end

    context "when user comments on their own pin" do
      let(:pin) { create(:pin, user: user, user_uid: user.uid) }

      it "does not create a notification" do
        expect {
          described_class.call(
            user: user,
            pin: pin,
            params: { content: "Hello" }
          )
        }.not_to change(Notification, :count)
      end
    end

    context "when replying to a parent comment" do
      let(:parent_user) { create(:user) }
      let(:parent_comment) do
        create(:comment, pin: pin, user: parent_user)
      end

      it "notifies the parent comment owner" do
        expect {
          described_class.call(
            user: user,
            pin: pin,
            params: { content: "Reply", parent_id: parent_comment.id }
          )
        }.to change(Notification, :count).by(2)
        # 1 for pin owner, 1 for parent comment owner
      end

      it "does not notify parent if parent user is the commenter" do
        parent_comment = create(:comment, pin: pin, user: user)

        expect {
          described_class.call(
            user: user,
            pin: pin,
            params: { content: "Reply", parent_id: parent_comment.id }
          )
        }.to change(Notification, :count).by(1)
      end

      it "does not notify parent if parent user is the pin owner" do
        parent_comment = create(:comment, pin: pin, user: pin_owner)

        expect {
          described_class.call(
            user: user,
            pin: pin,
            params: { content: "Reply", parent_id: parent_comment.id }
          )
        }.to change(Notification, :count).by(1)
      end
    end

    context "when pin has tagged users" do
      let(:tagged_user) { create(:user) }

      before do
        allow(pin).to receive(:tagged_users).and_return([tagged_user])
      end

      it "notifies tagged users" do
        expect {
          described_class.call(
            user: user,
            pin: pin,
            params: { content: "Hello" }
          )
        }.to change(Notification, :count).by(2)
        # pin owner + tagged user
      end

      it "does not notify the commenter if they are tagged" do
        allow(pin).to receive(:tagged_users).and_return([user])

        expect {
          described_class.call(
            user: user,
            pin: pin,
            params: { content: "Hello" }
          )
        }.to change(Notification, :count).by(1)
      end
    end

    context "when comment fails to save" do
      it "returns the unsaved comment and does not notify" do
        result = described_class.call(
          user: user,
          pin: pin,
          params: { content: "" }
        )

        expect(result).to be_a(Comment)
        expect(result).not_to be_persisted
        expect(Notification.count).to eq(0)
      end
    end
  end
end
