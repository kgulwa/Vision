FactoryBot.define do
  factory :pin do
    title       { "Test Pin" }
    description { "Test description" }

    # Associate user properly (lets tests override user)
    association :user, factory: :user

    # Ensure user_uid matches the associated user
    after(:build) do |pin|
      pin.user_uid = pin.user.uid
    end

    trait :with_image do
      after(:build) do |pin|
        file_path = Rails.root.join("spec", "fixtures", "files", "test.png")

        if File.exist?(file_path)
          pin.file.attach(
            io: File.open(file_path),
            filename: "test.png",
            content_type: "image/png"
          )
        end
      end
    end
  end
end
