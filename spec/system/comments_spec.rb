require 'rails_helper'

RSpec.describe "Comments", type: :system do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:tweet) { create(:tweet, user: user) }
  let!(:comment) { create(:comment, user: user, tweet: tweet) }

  context "コメントの登録＆削除" do
    it "自分のツイートに対するコメントの登録＆削除が正常に完了すること" do
      login_for_system(user)
      visit tweet_path(tweet)
      fill_in "comment_content", with: "今日は何件いきましたか？"
      click_button "コメント"
      within find("#comment-#{Comment.last.id}") do
        expect(page).to have_selector 'span', text: user.name
        expect(page).to have_selector 'span', text: '今日は何件いきましたか？'
      end
      expect(page).to have_content "コメントを追加しました！"
      click_link "削除", href: comment_path(Comment.last)
      expect(page).not_to have_selector 'span', text: 'コメントを追加しました！'
      expect(page).to have_content "コメントを削除しました"
    end

    it "別ユーザーのツイートのコメントには削除リンクが無いこと" do
      login_for_system(other_user)
      visit tweet_path(tweet)
      within find("#comment-#{comment.id}") do
        expect(page).to have_selector 'span', text: user.name
        expect(page).to have_selector 'span', text: comment.content
        expect(page).not_to have_link '削除', href: tweet_path(tweet)
      end
    end
  end
end
