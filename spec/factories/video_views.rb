FactoryBot.define do
  factory :video_view do
    association :user
    association :pin
    duration_seconds { 1 }
    started_at { Time.current }
    ended_at { Time.current }
  end
end
