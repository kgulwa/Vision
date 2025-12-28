require "rails_helper"

RSpec.describe Pin, type: :model do
  let(:user) do
    User.create!(
      username: "tester",
      email: "test@example.com",
      password: "password",
      password_confirmation: "password",
      uid: "abc123"
    )
  end

  let(:image_path) { Rails.root.join("spec", "fixtures", "files", "test.png") }

  describe "#to_param" do
    it "returns the id" do
      pin = Pin.create!(title: "Param", user: user)
      expect(pin.to_param).to eq(pin.id)
    end
  end

  describe "associations" do
    it { should belong_to(:user).with_foreign_key(:user_uid).with_primary_key(:uid) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:likes).dependent(:destroy) }
    it { should have_many(:reposts).dependent(:destroy) }
    it { should have_many(:saved_pins).dependent(:destroy) }
    it { should have_many(:video_views).dependent(:destroy) }
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
      pin1 = Pin.create!(title: "Old", user: user)
      pin2 = Pin.create!(title: "New", user: user)

      expect(Pin.recent.first).to eq(pin2)
    end

    it "includes only pins with existing users" do
      valid_pin = Pin.create!(title: "Valid", user: user)
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
      pin.file.attach(
        io: File.open(image_path),
        filename: "test.png",
        content_type: "image/png"
      )

      expect(pin.image).to eq(pin.file)
      expect(pin.video).to be_nil
    end

    it "returns file for video" do
      pin.file.attach(
        io: File.open(image_path),
        filename: "fake.mp4",
        content_type: "video/mp4"
      )

      expect(pin.video).to eq(pin.file)
      expect(pin.image).to be_nil
    end
  end

  describe "#display_thumbnail" do
    it "returns the attached thumbnail" do
      pin = Pin.create!(title: "Thumb", user: user)

      pin.thumbnail.attach(
        io: File.open(image_path),
        filename: "thumb.png",
        content_type: "image/png"
      )

      expect(pin.display_thumbnail).to be_attached
    end

    it "returns nil when no thumbnail is attached" do
      pin = Pin.create!(title: "No Thumb", user: user)
      expect(pin.display_thumbnail).to be_nil
    end
  end

  describe "#acceptable_file" do
    it "is valid without a file attached" do
      pin = Pin.new(title: "No File", user: user)
      pin.validate

      expect(pin.errors[:file]).to be_empty
    end

    it "adds an error if file is larger than 50MB" do
      pin = Pin.new(title: "Big File", user: user)

      allow_any_instance_of(ActiveStorage::Blob)
        .to receive(:byte_size)
        .and_return(51.megabytes)

      pin.file.attach(
        io: File.open(image_path),
        filename: "big.png",
        content_type: "image/png"
      )

      pin.validate
      expect(pin.errors[:file]).to include("is too large. Max size is 50MB")
    end

    it "adds an error for invalid content type" do
      pin = Pin.new(title: "Bad Type", user: user)

      pin.file.attach(
        io: File.open(image_path),
        filename: "bad.txt",
        content_type: "text/plain"
      )

      pin.validate
      expect(pin.errors[:file]).to include("must be PNG, JPG, HEIC, MP4, or MOV")
    end
  end

  describe "#generate_default_thumbnail" do
    it "does nothing if thumbnail already exists" do
      pin = Pin.create!(title: "Thumb Exists", user: user)

      pin.thumbnail.attach(
        io: File.open(image_path),
        filename: "thumb.png",
        content_type: "image/png"
      )

      expect(pin).not_to receive(:system)
      pin.send(:generate_default_thumbnail)
    end

    it "skips for non-video files" do
      pin = Pin.create!(title: "Image", user: user)

      pin.file.attach(
        io: File.open(image_path),
        filename: "test.png",
        content_type: "image/png"
      )

      expect(pin).not_to receive(:system)
      pin.send(:generate_default_thumbnail)
    end

    it "attempts to run ffmpeg for video files" do
      pin = Pin.create!(title: "Video", user: user)

      pin.file.attach(
        io: File.open(image_path),
        filename: "fake.mp4",
        content_type: "video/mp4"
      )

      expect(pin).to receive(:system)
      pin.send(:generate_default_thumbnail)
    end

    it "rescues errors during thumbnail generation" do
      pin = Pin.create!(title: "Rescue", user: user)

      pin.file.attach(
        io: File.open(image_path),
        filename: "fake.mp4",
        content_type: "video/mp4"
      )

      allow(pin).to receive(:system).and_raise(StandardError.new("ffmpeg failed"))

      expect {
        pin.send(:generate_default_thumbnail)
      }.not_to raise_error
    end
  end
end
