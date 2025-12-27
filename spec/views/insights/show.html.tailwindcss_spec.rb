require "rails_helper"

RSpec.describe "insights/show.html.tailwindcss", type: :view do
  it "exists as a template file" do
    path = Rails.root.join(
      "app/views/insights/show.html.tailwindcss"
    )

    expect(File).to exist(path)
  end
end
