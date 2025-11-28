require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#logged_in?' do
    it 'returns true when session has a user_id' do
      session[:user_id] = 1
      expect(helper.logged_in?).to eq(true)
    end

    it 'returns false when session has no user_id' do
      session[:user_id] = nil
      expect(helper.logged_in?).to eq(false)
    end
  end

  describe '#current_user' do
    let(:user) do
      User.create!(
        username: 'test',
        email: 'test@example.com',
        password: 'password',
        password_confirmation: 'password'
      )
    end

    it 'returns the current user' do
      session[:user_id] = user.id
      expect(helper.current_user).to eq(user)
    end

    it 'memoizes the user' do
      session[:user_id] = user.id
      helper.current_user
      expect(User).not_to receive(:find_by)
      helper.current_user
    end

    it 'returns nil when no user is logged in' do
      session[:user_id] = nil
      expect(helper.current_user).to be_nil
    end
  end

  # 🔥 NEW: unread notifications counter tests
  describe "#unread_notifications_count" do
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

    before do
      allow(helper).to receive(:current_user).and_return(user)
    end

    it "returns 0 when user has no unread notifications" do
      expect(helper.unread_notifications_count).to eq(0)
    end

    it "returns count of unread notifications" do
      Notification.create!(
        user: user,
        actor: actor,
        action: "liked",
        notifiable: actor,
        read: false
      )

      Notification.create!(
        user: user,
        actor: actor,
        action: "commented",
        notifiable: actor,
        read: false
      )

      expect(helper.unread_notifications_count).to eq(2)
    end

    it "ignores read notifications" do
      Notification.create!(
        user: user,
        actor: actor,
        action: "followed",
        notifiable: actor,
        read: true
      )

      expect(helper.unread_notifications_count).to eq(0)
    end
  end
end
