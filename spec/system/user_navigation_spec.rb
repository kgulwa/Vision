require "rails_helper"

RSpec.describe "User Navigation", type: :system do
  let(:user) { create(:user, password: "password123", password_confirmation: "password123") }

  before do
    driven_by(:rack_test)

    # Log in user
    visit login_path
    fill_in "username", with: user.username
    fill_in "password", with: "password123"
    click_button "Sign In"
  end

  it "views a pin page" do
    pin = create(:pin, user_uid: user.uid)

    visit pin_path(pin)

    # Must be logged in now, so the page should load
    expect(
      page.has_content?(pin.title) || page.has_css?("img")
    ).to be true
  end
end
