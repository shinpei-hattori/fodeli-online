FactoryBot.define do
  factory :chat_post do
    association :chat_room
    association :user
    message "はじめまして！"
  end
end
