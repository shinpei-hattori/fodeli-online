require 'rails_helper'

RSpec.describe "TweetsSpecs", type: :system do
  let!(:user) { create(:user) }
  let!(:tweet) { create(:tweet, user: user) }

  describe "ツイート詳細ページ" do
    context "ページレイアウト" do
      before do
        login_for_system(user)
        visit tweet_path(tweet)
      end

      it "正しいタイトルが表示されること" do
        expect(page).to have_title full_title("ツイートの詳細")
      end

      it "ツイート情報が表示されること" do
        expect(page).to have_link tweet.user.name, href: user_path(tweet.user)
        expect(page).to have_content tweet.content
        if tweet.user == user
          expect(page).to have_link "投稿を編集する", href: edit_tweet_path(tweet)
          expect(page).to have_link "削除", href: tweet_path(tweet)
        end
      end
    end

    context "ツイートの削除", js: true do
      it "削除成功のフラッシュが表示されること" do
        login_for_system(user)
        visit tweet_path(tweet)
        within find("#tweet-#{tweet.id}") do
          click_on '削除'
        end
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'ツイートを削除しました'
      end

      context "リダイレクト先", js: true do
        it "tweets/showページから削除した場合はホームにリダイレクトされること" do
          login_for_system(user)
          visit tweet_path(tweet)
          click_on '削除'
          page.driver.browser.switch_to.alert.accept
          expect(page).to have_title full_title
        end

        it "tweets/editページから削除した場合はホームにリダイレクトされること" do
          login_for_system(user)
          visit edit_tweet_path(tweet)
          click_on '削除'
          page.driver.browser.switch_to.alert.accept
          expect(page).to have_title full_title
        end

        it "users/showページから削除した場合は元のページにリダイレクトされること" do
          login_for_system(user)
          visit user_path(user)
          within find("#tweet-#{tweet.id}") do
            click_on '削除'
          end
          page.driver.browser.switch_to.alert.accept
          expect(page).to have_title full_title("プロフィール")
        end
      end
    end
  end

  describe "ツイート編集ページ" do
    before do
      login_for_system(user)
      visit tweet_path(tweet)
      click_link "投稿を編集する"
    end

    context "ページレイアウト", js: true do
      it "正しいタイトルが表示されること" do
        expect(page).to have_title full_title('ツイートの編集')
      end

      it "テクストエリアと内容が表示されているか" do
        expect(page).to have_css "#tweet_content"
        expect(page).to have_content tweet.content
      end

      it "削除成功のフラッシュが表示されること" do
        click_on '削除'
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'ツイートを削除しました'
      end
    end

    context "ツイートの更新処理" do
      it "有効な更新" do
        fill_in "tweet_content", with: "編集：今日は鍋食べる！"
        click_button "更新する"
        expect(page).to have_content "ツイートが更新されました！"
        expect(tweet.reload.content).to eq "編集：今日は鍋食べる！"
      end

      it "無効な更新" do
        fill_in "tweet_content", with: ""
        click_button "更新する"
        expect(page).to have_content 'ツイートを入力してください'
        expect(tweet.reload.content).not_to eq ""
      end
    end
  end
end
