require "rails_helper"

RSpec.describe "VideoViews", type: :request do
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
      user: user
    )
  end

  let(:video_view) do
    VideoView.create!(
      user: user,
      pin: pin,
      started_at: Time.current
    )
  end

  describe "PATCH /video_views/:id" do
    context "when logged in" do
      before do
        post login_path, params: { user: { username: user.username, password: "password" } }
      end

      it "updates the video view" do
        patch video_view_path(video_view), params: {
          video_view: { duration_seconds: 42 }
        }

        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)["status"]).to eq("ok")

        video_view.reload
        expect(video_view.duration_seconds).to eq(42)
        expect(video_view.ended_at).not_to be_nil
      end
    end

    context "when NOT logged in" do
      it "redirects to login" do
        patch video_view_path(video_view), params: {
          video_view: { duration_seconds: 50 }
        }

        expect(response).to redirect_to(login_path)
      end
    end
  end
end
