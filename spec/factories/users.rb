FactoryBot.define do
  factory :user do
    username { "test_#{SecureRandom.hex(3)}" }
    email { "user_#{SecureRandom.hex(4)}@example.com" }
    password { "password" }
    password_confirmation { "password" }

    
    email_verified { true }

    
    email_verification_token { nil }
    email_verification_sent_at { nil }

    
    trait :unverified do
      email_verified { false }
      email_verification_token { SecureRandom.urlsafe_base64 }
      email_verification_sent_at { Time.current }
    end
  end
end
