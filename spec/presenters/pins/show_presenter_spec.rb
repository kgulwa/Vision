require "rails_helper"

RSpec.describe Pins::ShowPresenter do
  let(:user) { create(:user) }
  let(:pin) { create(:pin) }
  let(:presenter) { described_class.new(pin: pin) }

  describe "#comments" do
    it "includes valid comments with a user and no parent" do
      comment = create(:comment, pin: pin, user: user, parent: nil)
      expect(presenter.comments).to include(comment)
    end

    it "excludes comments where the user is missing" do
      invalid_comment = build(:comment, pin: pin, user: nil)
      invalid_comment.save(validate: false)
      
      expect(presenter.comments).not_to include(invalid_comment)
    end

    it "excludes child comments if the parent's user is missing" do
      parent = build(:comment, user: nil)
      parent.save(validate: false)
      child = create(:comment, pin: pin, user: user, parent: parent)

      expect(presenter.comments).not_to include(child)
    end

    it "includes child comments if both they and their parent have users" do
      parent = create(:comment, user: user)
      child = create(:comment, pin: pin, user: user, parent: parent)

      expect(presenter.comments).to include(child)
    end
  end
end
