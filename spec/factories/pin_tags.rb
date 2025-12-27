FactoryBot.define do
  factory :pin_tag do
    association :pin
    association :tagged_user, factory: :user
    association :tagged_by, factory: :user
  end
end
