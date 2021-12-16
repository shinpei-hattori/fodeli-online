FactoryBot.define do
  factory :chat_user do
    association :user
    association :chat_room
  end
end
