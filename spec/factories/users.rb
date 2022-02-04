FactoryBot.define do
  factory :user, aliases: [:follower, :followed] do
    name { Faker::Name.name }
    sequence(:email) { |n| "example#{n}@example.com" }
    password { "foobar" }
    password_confirmation { "foobar" }
    introduction { "はじめまして。UverEatsやってます！よろしくお願いします！" }
    sex { "男性" }
    activated { true }
    activated_at { Time.zone.now }

    trait :admin do
      admin { true }
    end
  end
end
