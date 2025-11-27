require "rails_helper"

RSpec.describe Comment, type: :model do
  let(:user) do
    User.create!(
      username: "tester",
      email: "tester@example.com",
      password: "password",
      password_confirmation: "password"
    )
  end

  let(:pin) do
    Pin.create!(
      title: "Test Pin",
      description: "Pin description",
      user: user
    )
  end

  let(:comment) do
    Comment.create!(
      content: "Hello world",
      user: user,
      pin: pin
    )
  end

  # -------------------------------------------------------------
  # VALIDATIONS
  # -------------------------------------------------------------
  describe "validations" do
    it "is valid with content, user, and pin" do
      expect(comment).to be_valid
    end

    it "is invalid without content" do
      c = Comment.new(user: user, pin: pin)
      expect(c).not_to be_valid
      expect(c.errors[:content]).to include("can't be blank")
    end

    it "is valid without a user (anonymous comment)" do
      c = Comment.new(content: "Anon", pin: pin)
      expect(c).to be_valid
    end
  end

  # -------------------------------------------------------------
  # ASSOCIATIONS
  # -------------------------------------------------------------
  describe "associations" do
    it "belongs to a user (optional)" do
      assoc = Comment.reflect_on_association(:user)
      expect(assoc.macro).to eq(:belongs_to)
      expect(assoc.options[:optional]).to be(true)
    end

    it "belongs to a pin" do
      assoc = Comment.reflect_on_association(:pin)
      expect(assoc.macro).to eq(:belongs_to)
    end

    it "belongs to a parent comment (optional)" do
      assoc = Comment.reflect_on_association(:parent)
      expect(assoc.macro).to eq(:belongs_to)
      expect(assoc.options[:optional]).to be(true)
    end

    it "has many replies" do
      assoc = Comment.reflect_on_association(:replies)
      expect(assoc.macro).to eq(:has_many)
      expect(assoc.options[:foreign_key]).to eq(:parent_id)
    end

    it "destroys replies when deleted" do
      parent = Comment.create!(
        content: "Parent comment",
        user: user,
        pin: pin
      )

      reply = Comment.create!(
        content: "Child reply",
        user: user,
        pin: pin,
        parent: parent
      )

      expect { parent.destroy }.to change(Comment, :count).by(-2)
      expect(Comment.where(id: reply.id)).to be_empty
    end
  end

  # -------------------------------------------------------------
  # INSTANCE METHODS
  # -------------------------------------------------------------
  describe "#to_param" do
    it "returns the comment id" do
      expect(comment.to_param).to eq(comment.id)
    end
  end

  # -------------------------------------------------------------
  # SCOPES
  # -------------------------------------------------------------
  describe "scopes" do
    describe ".from_existing_users" do
      it "returns comments with user_id present" do
        anon = Comment.create!(content: "No user", pin: pin, user: nil)

        expect(Comment.from_existing_users).to include(comment)
        expect(Comment.from_existing_users).not_to include(anon)
      end
    end

    describe ".recent" do
      it "orders comments newest first" do
        older = Comment.create!(
          content: "Old comment",
          user: user,
          pin: pin,
          created_at: 2.days.ago
        )

        newer = Comment.create!(
          content: "New comment",
          user: user,
          pin: pin,
          created_at: 1.hour.ago
        )

        expect(Comment.recent.first).to eq(newer)
        expect(Comment.recent.last).to eq(older)
      end
    end
  end

  # -------------------------------------------------------------
  # NESTED COMMENT BEHAVIOR
  # -------------------------------------------------------------
  describe "nested comments" do
    it "can have nested replies" do
      reply = Comment.create!(
        content: "Reply",
        user: user,
        pin: pin,
        parent: comment
      )

      expect(comment.replies).to include(reply)
      expect(reply.parent).to eq(comment)
    end
  end
end
