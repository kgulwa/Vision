require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#logged_in?' do
    context 'when session has a user_id' do
      it 'returns true' do
        session[:user_id] = 1
        expect(helper.logged_in?).to eq(true)
      end
    end

    context 'when session does not have a user_id' do
      it 'returns false' do
        session[:user_id] = nil
        expect(helper.logged_in?).to eq(false)
      end
    end
  end

  describe '#current_user' do
    let(:user) { User.create!(username: 'test', email: 'test@example.com', password: 'password') }

    context 'when session has a valid user_id' do
      it 'returns the user' do
        session[:user_id] = user.id
        expect(helper.current_user).to eq(user)
      end

      it 'memoizes the user (does not run query again)' do
        session[:user_id] = user.id
        helper.current_user  # first call
        expect(User).not_to receive(:find_by)
        helper.current_user  # second call (should use memoized instance)
      end
    end

    context 'when session has no user_id' do
      it 'returns nil' do
        session[:user_id] = nil
        expect(helper.current_user).to eq(nil)
      end
    end
  end
end
