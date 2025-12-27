FactoryBot.define do
  factory :repost do
    association :user
    association :pin
  end
end
