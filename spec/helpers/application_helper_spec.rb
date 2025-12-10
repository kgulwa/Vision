require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do

  # --------------------------
  # LOGGED IN?
  # --------------------------
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

  # --------------------------
  # CURRENT USER
  # --------------------------
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

  # --------------------------
  # USER AVATAR
  # --------------------------
  describe '#user_avatar' do
    let(:user) { create(:user) }
    let(:avatar_path) { Rails.root.join("spec/fixtures/files/test.png") }

    context "when user has no avatar" do
      it "returns default avatar image tag" do
        html = helper.user_avatar(user)
        expect(html).to include("default-avatar")  # fingerprint safe
        expect(html).to include("img")
      end
    end

    context "when user has an avatar" do
      before do
        user.avatar.attach(
          io: File.open(avatar_path),
          filename: "test.png",
          content_type: "image/png"
        )
      end

      it "returns an HTML img tag with a variant URL" do
        html = helper.user_avatar(user)

        expect(html).to include("img")
        expect(html).to include("width=")
        expect(html).to include("height=")
      end
    end

    context "when variant processing fails" do
      before do
        allow(user).to receive_message_chain(:avatar, :attached?).and_return(true)
        allow(user.avatar).to receive(:variant).and_raise(StandardError)
      end

      it "falls back to default avatar" do
        html = helper.user_avatar(user)
        expect(html).to include("default-avatar")
      end
    end
  end

  # --------------------------
  # MENTIONS
  # --------------------------
  describe '#render_with_mentions' do
    let!(:user) do
      User.create!(
        username: 'konke',
        email: 'k@example.com',
        password: 'password',
        password_confirmation: 'password'
      )
    end

    it "returns empty string for blank text" do
      expect(helper.render_with_mentions(nil)).to eq("")
      expect(helper.render_with_mentions("")).to eq("")
    end

    it "returns original text if no mention exists" do
      expect(helper.render_with_mentions("hello world")).to eq("hello world")
    end

    it "does not convert mention if user does not exist" do
      expect(helper.render_with_mentions("Hello @ghost"))
        .to eq("Hello @ghost")
    end

    it "converts valid mention to link" do
      html = helper.render_with_mentions("Hi @konke")

      expect(html).to include("href=\"/users/#{user.uid}\"")
      expect(html).to include("@konke")
      expect(html).to include("text-blue-600")
    end
  end

  # --------------------------
  # UNREAD NOTIFICATIONS COUNT
  # --------------------------
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
