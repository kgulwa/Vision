FactoryBot.define do
  factory :saved_pin do
    association :pin
    association :collection
    association :user
  end
end
