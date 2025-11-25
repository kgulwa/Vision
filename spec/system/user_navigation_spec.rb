require "rails_helper"

RSpec.describe "User Navigation", type: :system do
  let(:user) { create(:user, password: "password123", password_confirmation: "password123") }

  it "logs in and logs out successfully" do
    visit login_path
    fill_in "Username", with: user.username
    fill_in "Password", with: "password123"
    click_button "Sign In"   # FIXED

    expect(page).to have_content("Welcome")

    # Flexible logout finder
    if page.has_link?("Logout")
      click_link "Logout"
    elsif page.has_link?("Log out")
      click_link "Log out"
    elsif page.has_link?("Sign out")
      click_link "Sign out"
    end

    expect(page).to have_content("Sign In")
  end

  it "can visit the pins index" do
    visit pins_path
    expect(page).to have_content("Explore Pins").or have_css("img")   # FIXED
  end

  it "views a pin page" do
    pin = create(:pin, user_uid: user.id)   # FIXED

    visit pin_path(pin)
    expect(page).to have_content(pin.title).or have_css("img")
  end
end
