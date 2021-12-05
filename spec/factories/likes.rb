FactoryBot.define do
  factory :like do
    association :tweet
    association :user
  end
end
