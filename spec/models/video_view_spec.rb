require "rails_helper"

RSpec.describe VideoView, type: :model do
  it "is valid with required associations" do
    user = create(:user)
    pin  = create(:pin, user: user)

    video_view = build(
      :video_view,
      user: user,
      pin: pin
    )

    expect(video_view).to be_valid
  end
end
