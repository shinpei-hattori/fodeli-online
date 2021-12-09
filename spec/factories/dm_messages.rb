FactoryBot.define do
  factory :dm_message do
    association :user
    association :dm_room
    message "こんにちは！"
  end
end
