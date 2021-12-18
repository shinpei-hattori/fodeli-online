FactoryBot.define do
  factory :area do
    city { Faker::Name.name }
    association :prefecture
  end
end
