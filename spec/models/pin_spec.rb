require "rails_helper"

RSpec.describe Pin, type: :model do
  let(:user) { User.create!(username: "tester", email: "test@example.com", password: "password", uid: "abc123") }
  let(:image_path) { Rails.root.join("spec", "fixtures", "test.png") }

  describe "associations" do
    it { should belong_to(:user).with_foreign_key(:user_uid).with_primary_key(:uid) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:likes).dependent(:destroy) }
    it { should have_many(:reposts).dependent(:destroy) }
    it { should have_many(:saved_pins).dependent(:destroy) }
    it { should have_many(:pin_tags).dependent(:destroy) }
    it { should have_many(:tagged_users).through(:pin_tags) }
    it { should have_one_attached(:file) }
    it { should have_one_attached(:thumbnail) }
  end

  describe "validations" do
    it { should validate_presence_of(:title) }
  end

  describe "scopes" do
    it "orders by recent" do
      pin1 = Pin.create!(title: "A", user: user)
      pin2 = Pin.create!(title: "B", user: user)
      expect(Pin.recent.first).to eq(pin2)
    end

    it "includes only pins with existing users" do
      valid_pin = Pin.create!(title: "A", user: user)
      expect(Pin.from_existing_users).to include(valid_pin)
    end
  end

  describe "#likes_count" do
    it "returns the number of likes" do
      pin = Pin.create!(title: "Test", user: user)
      Like.create!(pin: pin, user: user)
      expect(pin.likes_count).to eq(1)
    end
  end

  describe "#comments_count" do
    it "returns the number of comments" do
      pin = Pin.create!(title: "Test", user: user)
      Comment.create!(pin: pin, user: user, content: "Nice")
      expect(pin.comments_count).to eq(1)
    end
  end

  describe "#image and #video helpers" do
    let(:pin) { Pin.create!(title: "Media", user: user) }

    it "returns file for image" do
      pin.file.attach(io: File.open(image_path), filename: "test.png", content_type: "image/png")
      expect(pin.image).to eq(pin.file)
      expect(pin.video).to be_nil
    end

    it "returns file for video" do
      pin.file.attach(io: File.open(image_path), filename: "test.mp4", content_type: "video/mp4") # using image file as dummy
      expect(pin.video).to eq(pin.file)
      expect(pin.image).to be_nil
    end
  end

  describe "#display_thumbnail" do
    it "returns the attached thumbnail" do
      pin = Pin.create!(title: "Test", user: user)
      pin.thumbnail.attach(io: File.open(image_path), filename: "thumb.png", content_type: "image/png")
      expect(pin.display_thumbnail).to be_attached
    end
  end

  describe "#generate_default_thumbnail" do
    it "does nothing if thumbnail already exists" do
      pin = Pin.create!(title: "Thumb Test", user: user)
      pin.thumbnail.attach(io: File.open(image_path), filename: "thumb.png")

      expect(pin).not_to receive(:system)
      pin.send(:generate_default_thumbnail)
    end

    it "skips for non-video files" do
      pin = Pin.create!(title: "Image Test", user: user)
      pin.file.attach(io: File.open(image_path), filename: "test.png", content_type: "image/png")

      expect(pin).not_to receive(:system)
      pin.send(:generate_default_thumbnail)
    end

    it "attempts to run ffmpeg for video files" do
      pin = Pin.create!(title: "Video Test", user: user)
      pin.file.attach(io: File.open(image_path), filename: "fake.mp4", content_type: "video/mp4")

      expect(pin).to receive(:system)
      pin.send(:generate_default_thumbnail)
    end
  end
end
