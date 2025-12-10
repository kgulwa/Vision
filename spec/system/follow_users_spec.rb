require 'rails_helper'

RSpec.describe "Following users", type: :system do
  let(:user) do
    create(:user,
      password: "password123",
      password_confirmation: "password123"
    )
  end

  let(:other_user) { create(:user, password: "password123", password_confirmation: "password123") }

  before do
    driven_by(:rack_test)

    visit login_path
    fill_in "username", with: user.username
    fill_in "password", with: "password123"
    click_button "Sign In"
  end

  it "allows following and unfollowing from the profile page" do
    visit user_path(other_user)

    expect(page).to have_button("Follow")

    click_button "Follow"

    expect(page).to have_button("Following")
    expect(user.reload.following?(other_user)).to be true

    click_button "Following"

    expect(page).to have_button("Follow")
    expect(user.reload.following?(other_user)).to be false
  end
end
