FactoryBot.define do
  factory :comment do
    content { "Test comment" }

    association :user
    association :pin
  end
end
