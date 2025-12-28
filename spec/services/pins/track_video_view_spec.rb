require "rails_helper"

RSpec.describe Pins::TrackVideoView do
  let(:user) { create(:user) }

  describe ".call" do
    context "when pin has a video attached" do
      let(:pin) { create(:pin, user: user) }

      before do
        pin.file.attach(
          io: File.open(Rails.root.join("spec/fixtures/files/test_video.mp4")),
          filename: "test_video.mp4",
          content_type: "video/mp4"
        )
      end

      it "creates a VideoView record" do
        expect {
          described_class.call(user: user, pin: pin)
        }.to change(VideoView, :count).by(1)

        video_view = VideoView.last
        expect(video_view.user_uid).to eq(user.uid)
        expect(video_view.pin_id).to eq(pin.id)
        expect(video_view.started_at).to be_present
      end
    end

    context "when pin does NOT have a video attached" do
      let(:pin) { create(:pin, user: user) }

      it "does not create a VideoView record" do
        expect {
          described_class.call(user: user, pin: pin)
        }.not_to change(VideoView, :count)
      end
    end
  end
end
