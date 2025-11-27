require "rails_helper"

RSpec.describe "User Navigation", type: :system do
  let(:user) { create(:user, password: "password123", password_confirmation: "password123") }

  it "logs in and logs out successfully" do
    visit login_path
    fill_in "Username", with: user.username
    fill_in "Password", with: "password123"
    click_button "Sign In"

    expect(page).to have_content("Welcome")

    # Try common link/button text
    if page.has_link?("Sign out")
      click_link "Sign out"
    elsif page.has_button?("Sign out")
      click_button "Sign out"
    elsif page.has_link?("Logout")
      click_link "Logout"
    elsif page.has_button?("Logout")
      click_button "Logout"
    elsif page.has_link?("Log out")
      click_link "Log out"
    elsif page.has_button?("Log out")
      click_button "Log out"
    else
      # FINAL guaranteed fallback: find and submit the turbo DELETE form
      form = find("form[action='#{logout_path}']", match: :first)
      form.find("input[type=submit], button").click
    end

    expect(page).to have_content("Sign In")
  end

  it "can visit the pins index" do
    visit pins_path
    expect(page).to have_content("Explore Pins").or have_css("img")
  end

  it "views a pin page" do
    pin = create(:pin, user_id: user.id)
    visit pin_path(pin)
    expect(page).to have_content(pin.title).or have_css("img")
  end
end
