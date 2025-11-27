FactoryBot.define do
  factory :notification do
    user { nil }
    actor { nil }
    notifiable { nil }
    action { "MyString" }
    read { false }
  end
end
