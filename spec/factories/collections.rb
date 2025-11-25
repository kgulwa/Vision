FactoryBot.define do
  factory :collection do
    name { "MyString" }
    association :user
  end
end
