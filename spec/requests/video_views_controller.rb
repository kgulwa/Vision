require "rails_helper"

RSpec.describe "VideoViewsController", type: :request do
  let(:user) do
    User.create!(
      username: "tester",
      email: "test@example.com",
      password: "password",
      password_confirmation: "password",
      uid: "abc123"
    )
  end

  let(:pin) do
    Pin.create!(
      title: "Test Pin",
      user_uid: user.uid
    )
  end

  let(:video_view) do
    VideoView.create!(
      user_uid: user.uid,
      pin: pin,
      started_at: 1.minute.ago,
      duration_seconds: 5
    )
  end

  # Fake login helper to satisfy require_login
  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
  end

  describe "PATCH /video_views/:id" do
    it "updates the video view and returns JSON success" do
      patch video_view_path(video_view), params: {
        video_view: { duration_seconds: 42 }
      }

      expect(response).to have_http_status(:success)

      json = JSON.parse(response.body)
      expect(json["status"]).to eq("ok")

      video_view.reload
      expect(video_view.duration_seconds).to eq(42)
      expect(video_view.ended_at).to be_present
    end
  end

  describe "when NOT logged in" do
    before do
      allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(false)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(nil)
    end

    it "redirects to login" do
      patch video_view_path(video_view), params: {
        video_view: { duration_seconds: 50 }
      }

      expect(response).to have_http_status(302)
      expect(response).to redirect_to(login_path)
    end
  end
end
