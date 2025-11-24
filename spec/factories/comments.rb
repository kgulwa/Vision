FactoryBot.define do
  factory :comment do
    content { "Test comment" }
    user_uid { create(:user).uid }
    association :pin
  end
end
