FactoryBot.define do
  factory :pin do
    title       { "Test Pin" }
    description { "Test description" }

    # Associate a user unless tests override user_uid manually
    association :user, factory: :user

    # Ensure user_uid matches associated user unless already set by test
    after(:build) do |pin|
      # If test provides pin.user_uid explicitly, do NOT override it
      # If pin.user exists, assign its UID
      pin.user_uid ||= pin.user&.uid
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
