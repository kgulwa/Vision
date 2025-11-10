require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:email) }
    it { should have_secure_password }
    
    # Create a user first for uniqueness tests
    subject { User.new(username: 'testuser', email: 'test@example.com', password: 'password123') }
    
    it { should validate_uniqueness_of(:username) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    
    it { should allow_value('user@example.com').for(:email) }
    it { should_not allow_value('invalid_email').for(:email) }
    
    it 'validates password length' do
      user = User.new(username: 'testuser', email: 'test@example.com', password: '12345')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include('is too short (minimum is 6 characters)')
    end
  end

  describe 'associations' do
    it { should have_many(:pins).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:likes).dependent(:destroy) }
    it { should have_many(:reposts).dependent(:destroy) }
  end

  describe 'duplicate email prevention' do
    it 'does not allow duplicate emails' do
      User.create!(username: 'user1', email: 'test@example.com', password: 'password123')
      duplicate_user = User.new(username: 'user2', email: 'test@example.com', password: 'password123')
      
      expect(duplicate_user).to_not be_valid
      expect(duplicate_user.errors[:email]).to include('has already been taken')
    end

    it 'does not allow duplicate emails with different cases' do
      User.create!(username: 'user1', email: 'test@example.com', password: 'password123')
      duplicate_user = User.new(username: 'user2', email: 'TEST@example.com', password: 'password123')
      
      expect(duplicate_user).to_not be_valid
      expect(duplicate_user.errors[:email]).to include('has already been taken')
    end
  end

  describe 'password authentication' do
    let(:user) { User.create!(username: 'testuser', email: 'test@example.com', password: 'password123') }

    it 'authenticates with correct password' do
      expect(user.authenticate('password123')).to eq(user)
    end

    it 'does not authenticate with incorrect password' do
      expect(user.authenticate('wrongpassword')).to be_falsey
    end

    it 'stores password securely (not plain text)' do
      expect(user.password_digest).not_to eq('password123')
      expect(user.password_digest).to be_present
    end
  end
end