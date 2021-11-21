User.create!(name:  "山田 太郎",
  email: "sample@example.com",
  password:              "foobar",
  password_confirmation: "foobar",
  admin: true)

99.times do |n|
name  = Faker::Name.name
email = "sample-#{n+1}@example.com"
password = "password"
User.create!(name:  name,
    email: email,
    password:              password,
    password_confirmation: password)
end

10.times do |n|
Tweet.create!(
  content: "UverEats楽しい！",
  user_id: 1
)
end