require 'rails_helper'

RSpec.describe "Notifications", type: :system do
  let!(:user) { create(:user) }
  let!(:second) { create(:user) }
  let!(:third) { create(:user) }
  let!(:tweet) { create(:tweet, user: user) }
  let!(:other_tweet) { create(:tweet,user: second,content: "今夜は焼肉だ!") }
  let!(:comment1) { create(:comment, tweet: tweet,user: second ,content: "素敵です!") }

  context "通知一覧画面の確認" do
    before do
      # ◯◯があなたをフォローしました
      create(:notification,visitor: second,visited: user,action: "follow")
      # ◯◯があなたの投稿をいいねしました
      create(:notification,visitor: second,visited: user,tweet: tweet,action: "like")
      # # ◯◯があなたの投稿にコメントしました
      create(:notification,visitor: second,visited: user,tweet: tweet,comment: comment1,action: "comment")
      # # ◯◯が◯◯の投稿にコメントしました
      create(:comment,tweet: other_tweet,user: user,content: "いいですね!")
      comment = create(:comment,tweet: other_tweet,user: third,content: "羨ましい!")
      create(:notification,visitor: third,visited: user,tweet: other_tweet,comment: comment,action: "comment")
      login_for_system(user)
      visit notifications_path
    end

    it "期待する通知一覧が表示されること" do
      expect(page).to have_content 'をフォローしました'
      expect(page).to have_content 'にいいねしました'
      expect(page).to have_content 'にコメントしました', count: 2

      expect(page).to have_link "あなた",href: user_path(user)
      expect(page).to have_link "あなたの投稿",href: tweet_path(tweet), count: 2
      expect(page).to have_link second.name,href: user_path(second), count: 3
      expect(page).to have_link third.name,href: user_path(third)
      expect(page).to have_link "#{ second.name }さんの投稿",href: tweet_path(other_tweet)
    end

  end
end
