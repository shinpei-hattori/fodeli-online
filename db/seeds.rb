Dir.glob(File.join(Rails.root, 'db', 'seeds', '*.rb')) do |file|
  load(file)
end

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

# マイクロポスト
users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.tweets.create!(content: content) }
end

# リレーションシップ
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

#個人チャット
users = User.all
user  = users.first
10.times do |n|
  DmRoom.create
end
rooms = DmRoom.all
rooms.each_with_index do |a,i|
  DmEntrie.create!(user: user,dm_room: a)
  DmEntrie.create!(user: users[i+2],dm_room: a)
  content = Faker::Lorem.sentence(word_count: 5)
  DmMessage.create!(user: user,dm_room: a,message: content)
  DmMessage.create!(user: users[i+2],dm_room: a,message: content)
end

# フードデリバリー会社作成

c = [
  "Uber Eats","出前館","DiDi Food","menu",
  "Chompy","Wolt","foodpanda","DOORDASH"
]
c.each { |n| Company.create!(name: n)}

# チャットルームとメッセージ作成
company = Company.where(name: ["Uber Eats","出前館"])
areas = Area.where(city: ["さいたま市","市川市","渋谷区","横浜市"])
users = User.all[2..15]
user = User.first
company.each do |c|
  areas.each do |a|
    content = Faker::Lorem.sentence(word_count: 5)
    room = ChatRoom.create!(company: c,area: a)
    ChatUser.create!(user: user,chat_room: room)
    user.chat_posts.create!(chat_room: room,message: content)
    users.each do |u|
      ChatUser.create!(user: u,chat_room: room)
      u.chat_posts.create!(chat_room: room,message: content)
    end
  end
end
