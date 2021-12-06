FactoryBot.define do
  factory :comment do
    # user_id { 1 }
    content "今日は何件配達しましたか？"
    association :tweet
    association :user
  end
end
