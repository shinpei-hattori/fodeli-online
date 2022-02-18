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

      context "ツイートフォーム" do
        it "フォームが存在すること" do
          login_for_system(user)
          visit root_path
          expect(page).to have_css "section.user_info"
          expect(page).to have_css "section.tweet_form"
        end
        context "ツイート新規登録" do
          it "無効な情報で投稿を行うと失敗のエラーが表示されること" do
            login_for_system(user)
            visit root_path
            fill_in "tweet_content", with: ""
            click_button "投稿"
            expect(page).to have_content "ツイートを入力してください"
          end
          it "有効な情報で投稿を行うと成功時のフラッシュが表示されること" do
            login_for_system(user)
            visit root_path
            fill_in "tweet_content", with: "今日は８時間稼働します！"
            click_button "投稿"
            expect(page).to have_content "ツイートを投稿しました！"
          end

          it "画像を選択し投稿するとツイートに画像が反映されていること" do
            login_for_system(user)
            visit root_path
            fill_in "tweet_content", with: "今日は８時間稼働します！"
            attach_file 'tweet_pictures', "#{Rails.root}/spec/fixtures/files/test_image.jpg"
            click_button "投稿"
            expect(page).to have_selector("img[src$='test_image.jpg']")
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

      context "ツイート検索" do
        it "期待した検索結果が表示されること" do
          login_for_system(user)
          create(:tweet, user: user, content: "オレンジ")
          create(:tweet, user: user, content: "レンジ")
          create(:tweet, user: user, content: "レン")
          create(:tweet, user: user, content: "アップル")
          visit root_path
          fill_in "keyword", with: "レン"
          click_button "Search"
          expect(page).to have_content "3件ヒットしました"
          expect(page).to have_content "オレンジ"
          expect(page).to have_content "レンジ"
          expect(page).to have_content "レン"
          expect(page).not_to have_content "アップル"
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
      expect(page).to have_content 'ツイート機能'
      expect(page).to have_content 'フォロワー機能'
      expect(page).to have_content '個人チャット機能'
      expect(page).to have_content '全国チャット機能'
    end

    it "正しいタイトルが表示されることを確認" do
      expect(page).to have_title full_title('使い方')
    end
  end
end
