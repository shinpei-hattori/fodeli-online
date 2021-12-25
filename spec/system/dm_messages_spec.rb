require 'rails_helper'

RSpec.describe "dm_messages", type: :system do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:third) { create(:user) }
  let!(:relationship1) { create(:relationship, follower: user, followed: other_user) }
  let!(:relationship2) { create(:relationship, follower: other_user, followed: user) }
  let!(:room) { create(:dm_room) }
  let!(:room2) { create(:dm_room) }
  let!(:entry1) { create(:dm_entry, user: user, dm_room: room) }
  let!(:entry2) { create(:dm_entry, user: other_user, dm_room: room) }

  describe "個人チャットページ" do
    context "チャットボタンの確認" do
      context "相互フォロワーで既にルームを作成している場合" do
        before do
          login_for_system(user)
          visit user_path(other_user)
        end

        it "「チャットへ」ボタンがあること" do
          expect(page).to have_content "チャットへ"
        end
      end

      context "相互フォロワーだがルームを作成していない場合" do
        before do
          create(:relationship, follower: user, followed: third)
          create(:relationship, follower: third, followed: user)
          login_for_system(user)
          visit user_path(third)
        end

        it "「チャットを始める」ボタンがあること" do
          expect(page).to have_button 'チャットを始める'
        end
      end

      context "相互フォロワーでない場合" do
        before do
          login_for_system(user)
          visit user_path(third)
        end

        it "「チャットを始める」ボタンも「チャットへ」ボタンも表示されないこと" do
          expect(page).not_to have_button 'チャットを始める'
          expect(page).not_to have_content "チャットへ"
        end
      end
    end

    context "チャットページ" do
      context "レイアウト" do
        before do
          login_for_system(user)
          visit user_path(other_user)
          click_link "チャットへ"
        end

        it "チャット画面の情報が表示されていること" do
          expect(page).to have_title full_title("個人チャット")
          expect(page).to have_content "#{other_user.name}さんとのチャット"
          expect(page).to have_link "#{other_user.name}さん", href: user_path(other_user.id)
          expect(page).to have_link "#{user.name}さん", href: user_path(user.id)
          expect(page).to have_field "dm_message[message]"
          expect(page).to have_button '投稿'
        end
      end

      context "メッセージ投稿" do
        before do
          login_for_system(user)
          visit user_path(other_user)
          click_link "チャットへ"
        end

        it "メッセージを投稿するとチャット画面にメッセージと日付と時間が表示されること", js: true do
          fill_in "dm_message_message", with: "今日ラーメンいかない？"
          click_button "投稿"
          expect(page).to have_content "今日ラーメンいかない？"
          expect(page).to have_content DmMessage.last.created_at.strftime('%H:%M')
          expect(page).to have_content DmMessage.last.post_datetime
          expect(page).to have_title full_title("個人チャット")
        end
      end

      context "メッセージの削除" do
        before do
          create(:dm_message, message: "うどん食べたい", user: user, dm_room: room)
          create(:dm_message, message: "そば食べたい", user: other_user, dm_room: room)
          login_for_system(user)
          visit user_path(other_user)
          click_link "チャットへ"
        end

        it "自分自身のみ削除リンクが表示されていること", js: true do
          expect(page).to have_content "うどん食べたい"
          expect(page).to have_content "そば食べたい"
          expect(page).to have_link "", href: dm_message_path(user.dm_messages.last)
          expect(page).not_to have_link "", href: dm_message_path(other_user.dm_messages.last)
        end

        it "メッセージを削除するとチャット画面にメッセージが表示されないこと", js: true do
          click_link "chat-delete"
          page.driver.browser.switch_to.alert.accept
          expect(page).not_to have_content "うどん食べたい"
          expect(page).to have_title full_title("個人チャット")
        end
      end
    end

    context "個人チャット履歴ページ" do
      before do
        create(:dm_message, message: "うどん食べたい", user: user, dm_room: room)
        create(:dm_message, message: "うなぎ食べたい", user: third, dm_room: room2)
        create(:relationship, follower: user, followed: third)
        create(:relationship, follower: third, followed: user)
        create(:dm_entry, user: user, dm_room: room2)
        create(:dm_entry, user: third, dm_room: room2)
        login_for_system(user)
        visit dmlists_user_path(user)
      end

      it "コンテンツが表示されているか" do
        expect(page).to have_content "個人チャット履歴"
        expect(page).to have_title full_title("個人チャット履歴")
        expect(page).to have_content "うどん食べたい"
        expect(page).to have_content "うなぎ食べたい"
        expect(page).to have_content "#{other_user.name}"
        expect(page).to have_content "#{third.name}"
      end
    end
  end
end
