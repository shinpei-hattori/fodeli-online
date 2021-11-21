require 'rails_helper'

RSpec.describe "StaticPages", type: :system do

  describe "トップページ" do
    let!(:user) { create(:user) }
    let!(:tweet) { create(:tweet, user: user) }
    context "ページ全体" do
      before do
        visit root_path
      end

      it "該当の文字列が存在することを確認" do
        expect(page).to have_content 'Fodeli Onlineとは？'
      end

      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title
      end

      it "ツイートフォーム" do
        login_for_system(user)
        visit root_path
        expect(page).to have_css "section.user_info"
        expect(page).to have_css "section.tweet_form"
      end

      context "ツイートフィード", js: true do
        it "ツイートのぺージネーションが表示されることと投稿したユーザーであれば削除リンクが表示されていること" do
          login_for_system(user)
          create_list(:tweet, 6, user: user)
          visit root_path
          expect(page).to have_content "みんなのツイート"
          expect(page).to have_content "(#{user.tweets.count})"
          expect(page).to have_css "ul.pagination"
          if user.id == tweet.user_id
            expect(page).to have_link "削除"
          else
            expect(page).not_to have_link "削除"
          end
          Tweet.take(5).each do |t|
            expect(page).to have_content t.content
          end
        end
      end

      context "ツイート削除処理", js: true do
        it "正しく削除できること" do
          login_for_system(user)
          visit root_path
          click_on "削除"
          page.driver.browser.switch_to.alert.accept
          expect(page).to have_content "ツイートを削除しました！"
        end
      end

    end
  end

  describe "aboutページ" do
    before do
      visit about_path
    end

    it "該当の文字列が存在することを確認" do
      expect(page).to have_content 'Foldeli Onlineの使い方'
    end

    it "正しいタイトルが表示されることを確認" do
      expect(page).to have_title full_title('使い方')
    end
  end
end
