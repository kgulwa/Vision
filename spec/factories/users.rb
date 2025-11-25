FactoryBot.define do
  factory :user do
    username { "test_#{SecureRandom.hex(3)}" }
    email { "user_#{SecureRandom.hex(4)}@example.com" }
    password { "password" }
    password_confirmation { "password" }

  end
end
