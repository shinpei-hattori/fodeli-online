FactoryBot.define do
  factory :dm_entry, class: 'DmEntrie' do
    association :user
    association :dm_room
  end
end
