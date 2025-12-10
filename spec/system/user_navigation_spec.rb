require "rails_helper"

RSpec.describe "User Navigation", type: :system do
  let(:user) { create(:user, password: "password123", password_confirmation: "password123") }

  it "views a pin page" do
    pin = create(:pin, user_uid: user.uid)
    visit pin_path(pin)
    expect(page).to have_content(pin.title).or have_css("img")
  end
end
