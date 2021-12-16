FactoryBot.define do
  factory :chat_room do
    association :company
    association :area
  end
end
