require 'rails_helper'

RSpec.describe "Users", type: :system do
  let!(:user) { create(:user) }
  let!(:admin_user) { create(:user, :admin) }
  let!(:other_user) { create(:user) }
  let(:picture_path) { File.join(Rails.root, 'spec/fixtures/files/test_image.jpg') }
  let(:picture) { Rack::Test::UploadedFile.new(picture_path) }

  describe "ユーザー一覧ページ" do
    context "レイアウト" do
      it "ぺージネーション、削除ボタンが表示されること" do
        create_list(:user, 31)
        login_for_system(user)
        visit users_path
        expect(page).to have_css "ul.pagination"
        User.page(1).each do |u|
          expect(page).to have_link u.name, href: user_path(u)
        end
      end
    end

    context "ユーザー検索" do
      it "期待した検索結果が得られること" do
        login_for_system(user)
        create(:user, name: "jon")
        create(:user, name: "やまだ")
        create(:user, name: "やまおか")
        create(:user, name: "やましろ")
        visit users_path
        fill_in "keyword", with: "やま"
        click_button "Search"
        expect(page).to have_content "3名ヒットしました"
        expect(page).to have_content "やまだ"
        expect(page).to have_content "やまおか"
        expect(page).to have_content "やましろ"
        expect(page).not_to have_content "jon"
      end
    end

    context "管理者ユーザーの場合" do
      it "ぺージネーション、自分以外のユーザーの削除ボタンが表示されること" do
        create_list(:user, 30)
        login_for_system(admin_user)
        visit users_path
        expect(page).to have_css "ul.pagination"
        User.page(1).each do |u|
          expect(page).to have_link u.name, href: user_path(u)
          expect(page).to have_content "#{u.name} | 削除" unless u == admin_user
        end
      end
    end

    context "管理者ユーザー以外の場合" do
      it "ぺージネーション、自分のアカウントのみ削除ボタンが表示されること" do
        create_list(:user, 30)
        login_for_system(user)
        visit users_path
        expect(page).to have_css "ul.pagination"
        User.page(1).each do |u|
          expect(page).to have_link u.name, href: user_path(u)
          if u == user
            expect(page).to have_content "#{u.name} | 削除"
          else
            expect(page).not_to have_content "#{u.name} | 削除"
          end
        end
      end
    end
  end

  describe "ユーザー登録ページ" do
    before do
      visit signup_path
    end

    context "ページレイアウト" do
      it "「ユーザー登録」の文字列が存在することを確認" do
        expect(page).to have_content 'ユーザー登録'
      end

      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title('ユーザー登録')
      end
    end

    context "ユーザー登録処理" do
      it "有効なユーザーでユーザー登録を行うとユーザー登録成功のフラッシュが表示されること" do
        fill_in "ユーザー名", with: "Example User"
        fill_in "メールアドレス", with: "user@example.com"
        fill_in "パスワード", with: "password"
        fill_in "パスワード(確認)", with: "password"
        click_button "登録する"
        expect(page).to have_content "Fodeli Onlineへようこそ！"
      end

      it "無効なユーザーでユーザー登録を行うとユーザー登録失敗のフラッシュが表示されること" do
        fill_in "ユーザー名", with: ""
        fill_in "メールアドレス", with: "user@example.com"
        fill_in "パスワード", with: "password"
        fill_in "パスワード(確認)", with: "pass"
        click_button "登録する"
        expect(page).to have_content "ユーザー名を入力してください"
        expect(page).to have_content "パスワード(確認)とパスワードの入力が一致しません"
      end
    end
  end

  describe "プロフィール編集ページ" do
    before do
      login_for_system user
      visit user_path(user)
      click_link "プロフィール編集"
    end

    context "ページレイアウト" do
      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title('プロフィール編集')
      end
    end

    it "有効なプロフィール更新を行うと、更新成功のフラッシュが表示されること" do
      fill_in "ユーザー名", with: "Edit Example User"
      fill_in "メールアドレス", with: "edit-user@example.com"
      fill_in "自己紹介", with: "編集：初めまして"
      choose "女"
      click_button "更新する"
      expect(page).to have_content "プロフィールが更新されました！"
      expect(user.reload.name).to eq "Edit Example User"
      expect(user.reload.email).to eq "edit-user@example.com"
      expect(user.reload.introduction).to eq "編集：初めまして"
      expect(user.reload.sex).to eq "女"
    end

    it "無効なプロフィール更新をしようとすると、適切なエラーメッセージが表示されること" do
      fill_in "ユーザー名", with: ""
      fill_in "メールアドレス", with: ""
      click_button "更新する"
      expect(page).to have_content 'ユーザー名を入力してください'
      expect(page).to have_content 'メールアドレスを入力してください'
      expect(page).to have_content 'メールアドレスは不正な値です'
      expect(user.reload.email).not_to eq ""
    end

    context "アカウント削除処理", js: true do
      it "正しく削除できること" do
        click_link "アカウントを削除する"
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content "自分のアカウントを削除しました"
      end
    end
  end

  describe "プロフィールページ" do
    let(:tweet) { create(:tweet, user: user, pictures: [picture]) } # 画像表示確認用

    context "ページレイアウト" do
      before do
        login_for_system user
        create_list(:tweet, 10, user: user)
        tweet # 画像添付されているツイートを一番上に表示させるため
        visit user_path(user)
      end

      it "「プロフィール」の文字列が存在することを確認" do
        expect(page).to have_content 'プロフィール'
      end

      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title('プロフィール')
      end

      it "ユーザー情報が表示されることを確認" do
        expect(page).to have_content user.name
        expect(page).to have_content user.introduction
        expect(page).to have_content user.sex
      end

      it "プロフィール編集ページへのリンクが表示されていることを確認" do
        expect(page).to have_link 'プロフィール編集', href: edit_user_path(user)
      end

      it "ツイートの件数が表示されていることを確認" do
        expect(page).to have_content "ツイート (#{user.tweets.count})"
      end

      it "ツイートの情報と削除リンクが表示されていることを確認" do
        Tweet.take(5).each do |tweet|
          expect(page).to have_content tweet.content
          expect(page).to have_link "削除"
        end
      end

      it "ツイートのページネーションが表示されていることを確認" do
        expect(page).to have_css "ul.pagination"
      end

      it "画像が表示されていることを確認" do
        expect(page).to have_selector("img[src$='test_image.jpg']")
      end

      context "ユーザーのフォロー/アンフォロー処理", js: true do
        it "ユーザーのフォロー/アンフォローができること" do
          login_for_system(user)
          visit user_path(other_user)
          expect(page).to have_button 'フォローする'
          click_button 'フォローする'
          expect(page).to have_button 'フォロー中'
          click_button 'フォロー中'
          expect(page).to have_button 'フォローする'
        end
      end

      context "お気に入り登録/解除" do
        before do
          login_for_system(user)
        end

        it "ツイートのいいね登録/解除ができること" do
          expect(user.like?(tweet)).to be_falsey
          user.like(tweet)
          expect(user.like?(tweet)).to be_truthy
          user.unlike(tweet)
          expect(user.like?(tweet)).to be_falsey
        end
      end

      context "セレクトボックスの選択によって動的にコンテンツが変化すること" do
        let!(:like) { create(:like, user: user, tweet: tweet) }

        before do
          login_for_system(user)
        end

        it "デフォルトではツイート内容が表示されること" do
          t = tweet
          visit user_path(user)
          expect(page).to have_content "ツイート (#{user.tweets.count})"
          expect(page).to have_css "ul.tweets"
          expect(page).to have_css "li#tweet-#{t.id}"
        end
        it "いいねしたツイートを選択すると、いいねしたツイート内容が表示されること", js: true do
          visit user_path(user)
          select "いいねしたツイート", from: "status"
          expect(page).to have_content "いいねしたツイート (#{user.likes.count})"
          expect(page).to have_css "ul.like-tweet"
          expect(page).to have_css "li#tweet-#{like.tweet.id}"
        end

        it "参加中チャットを選択すると、参加チャット一覧が表示されること", js: true do
          chat_user = create(:chat_user, user: user)
          visit user_path(user)
          select "参加中チャット", from: "status"
          expect(page).to have_content "参加中チャット (#{user.chat_users.count})"
          expect(page).to have_css "ul.list-group"
          expect(page).to have_css "li#chat-#{chat_user.chat_room.id}"
        end
      end
    end
  end
end
