require "rails_helper"

RSpec.describe "User Navigation", type: :system do
  let(:user) { create(:user, password: "password123", password_confirmation: "password123") }

  it "logs in and logs out successfully" do
    visit login_path
    fill_in "Username", with: user.username
    fill_in "Password", with: "password123"
    click_button "Log In"

    expect(page).to have_content("Welcome") # home page

    click_link "Sign out"
    expect(page).to have_content("Sign In")
  end

  it "can visit the pins index" do
    visit pins_path
    expect(page).to have_content("Discover").or have_css("img")
  end

  it "views a pin page" do
    pin = create(:pin, user_uid: user.uid)

    visit pin_path(pin)
    expect(page).to have_content(pin.title).or have_css("img")
  end
end
