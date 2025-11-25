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
    let(:user) { User.create!(username: 'test', email: 'test@example.com', password: 'password') }

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

    it 'returns nil when no user_id is in session' do
      session[:user_id] = nil
      expect(helper.current_user).to eq(nil)
    end
  end
end
