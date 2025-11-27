require "rails_helper"

RSpec.describe Notification, type: :model do
  let(:recipient) do
    User.create!(
      username: "receiver",
      email: "receiver@example.com",
      password: "password",
      password_confirmation: "password"
    )
  end

  let(:actor) do
    User.create!(
      username: "actor",
      email: "actor@example.com",
      password: "password",
      password_confirmation: "password"
    )
  end

  let(:pin) do
    Pin.create!(
      title: "Test Pin",
      description: "Pin desc",
      user: actor
    )
  end

  let(:notification) do
    Notification.create!(
      user: recipient,
      actor: actor,
      action: "liked",
      notifiable: pin,
      read: false
    )
  end

 
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:actor).class_name("User") }
    it { should belong_to(:notifiable) }
  end

 
  describe "validations" do
    it "is valid with required attributes" do
      expect(notification).to be_valid
    end

    it "requires a recipient (user)" do
      n = Notification.new(
        actor: actor,
        action: "liked",
        notifiable: pin
      )
      expect(n).not_to be_valid
      expect(n.errors[:user]).to include("must exist")
    end

    it "requires an actor" do
      n = Notification.new(
        user: recipient,
        action: "liked",
        notifiable: pin
      )
      expect(n).not_to be_valid
      expect(n.errors[:actor]).to include("must exist")
    end

    it "requires a notifiable" do
      n = Notification.new(
        user: recipient,
        actor: actor,
        action: "liked"
      )
      expect(n).not_to be_valid
      expect(n.errors[:notifiable]).to include("must exist")
    end
  end

  
  describe ".unread" do
    it "returns only unread notifications" do
      read_notification = Notification.create!(
        user: recipient,
        actor: actor,
        action: "commented",
        notifiable: pin,
        read: true
      )

      expect(Notification.unread).to include(notification)
      expect(Notification.unread).not_to include(read_notification)
    end
  end

  
  describe "#actor_username" do
    it "returns the actor's username" do
      expect(notification.actor_username).to eq("actor")
    end
  end
end
