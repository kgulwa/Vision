require 'rails_helper'

RSpec.describe CommentsHelper, type: :helper do
  describe '#format_comment' do

    it 'returns an empty string for blank input' do
      expect(helper.format_comment("")).to eq("")
      expect(helper.format_comment(nil)).to eq("")
    end

    it 'turns @mentions into profile links' do
      user = User.create!(
        username: "konke",
        email: "a@example.com",
        password: "password",
        password_confirmation: "password"
      )

      formatted = helper.format_comment("Hello @konke")

      uid_or_id = user.respond_to?(:uid) && user.uid.present? ? user.uid : user.id

      # Accept single quotes (matches helper output)
      expect(formatted).to include("href='/users/#{uid_or_id}'")
      expect(formatted).to include("@konke")
    end

    it 'returns original text if user does not exist' do
      formatted = helper.format_comment("Hello @ghost")
      expect(formatted).to include("@ghost")
      expect(formatted).not_to include("href=")
    end

  end
end
