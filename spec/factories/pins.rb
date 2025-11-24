FactoryBot.define do
  factory :pin do
    title { "Test Pin" }
    description { "Test description" }
    user_uid { create(:user).uid }

    after(:build) do |pin|
      pin.image.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "files", "test.png")),
        filename: "test.png",
        content_type: "image/png"
      )
    end
  end
end
