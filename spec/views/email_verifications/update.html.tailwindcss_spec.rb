require "rails_helper"

RSpec.describe "email_verifications/update.html.tailwindcss", type: :view do
  it "exists as a template file" do
    path = Rails.root.join(
      "app/views/email_verifications/update.html.tailwindcss"
    )

    expect(File).to exist(path)
  end
end
