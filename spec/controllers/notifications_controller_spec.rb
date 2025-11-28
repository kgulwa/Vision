require "rails_helper"

RSpec.describe NotificationsController, type: :controller do
  let(:user) do
    User.create!(
      username: "userA",
      email: "a@example.com",
      password: "password",
      password_confirmation: "password"
    )
  end

  let(:actor) do
    User.create!(
      username: "userB",
      email: "b@example.com",
      password: "password",
      password_confirmation: "password"
    )
  end

  let(:pin) do
    Pin.create!(title: "Test", description: "Test desc", user: user)
  end

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET #index" do
    it "requires login" do
      allow(controller).to receive(:current_user).and_return(nil)
      get :index
      expect(response).to redirect_to(login_path)
    end

    it "returns a 200 status" do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it "loads the user's notifications" do
      Notification.create!(
        user: user,
        actor: actor,
        action: "liked",
        notifiable: pin
      )

      get :index

      expect(Notification.where(user: user).count).to be > 0
    end

    it "orders notifications newest first" do
      older = Notification.create!(
        user: user,
        actor: actor,
        action: "commented",
        notifiable: pin,
        created_at: 2.days.ago
      )

      newer = Notification.create!(
        user: user,
        actor: actor,
        action: "liked",
        notifiable: pin,
        created_at: 1.hour.ago
      )

      get :index

      ordered = Notification.where(user: user).order(created_at: :desc)
      expect(ordered.first).to eq(newer)
      expect(ordered.last).to eq(older)
    end

    it "marks unread notifications as read" do
      notification = Notification.create!(
        user: user,
        actor: actor,
        action: "liked",
        notifiable: pin,
        read: false
      )

      get :index
      expect(notification.reload.read).to be(true)
    end
  end
end
