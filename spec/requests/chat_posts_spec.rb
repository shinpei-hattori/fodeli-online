require 'rails_helper'

RSpec.describe "ChatPosts", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:third) { create(:user) }
  let!(:room) { create(:chat_room) }
  let!(:chat_user1) { create(:chat_user, user: user, chat_room: room) }
  let!(:chat_user2) { create(:chat_user, user: other_user, chat_room: room) }
  let!(:message) { create(:chat_post, user: user, chat_room: room, message: "ラーメン食べたい") }

  context "ログインしている場合" do
    before do
      login_for_request(user)
    end

    context "メッセージの投稿" do
      it "メッセージの投稿ができること" do
        expect {
          post chat_posts_path, params: { chat_post: { chat_room_id: chat_user1.chat_room_id, message: "ラーメン食べたい！" } }
        } .to change(ChatPost, :count).by(1)
        expect(response).to redirect_to chat_room_path(chat_user1.chat_room)
      end

      it "Ajaxによるメッセージの投稿ができること" do
        expect {
          post chat_posts_path, params: { chat_post: { chat_room_id: chat_user1.chat_room_id, message: "ラーメン食べたい！" } }, xhr: true
        } .to change(ChatPost, :count).by(1)
      end
    end

    context "メッセージの削除" do
      it "メッセージの削除ができること" do
        expect {
          delete chat_post_path(message.id)
        }        .to change(ChatPost, :count).by(-1)
        expect(response).to redirect_to chat_room_path(message.chat_room)
      end

      it "Ajaxによるメッセージの削除ができること" do
        expect {
          delete chat_post_path(message.id), xhr: true
        }        .to change(ChatPost, :count).by(-1)
      end
    end
  end

  context "ログインしていない場合" do
    context "メッセージの投稿" do
      it "メッセージの投稿ができずログイン画面にリダイレクトすること" do
        expect {
          post chat_posts_path, params: { chat_post: { chat_room_id: chat_user1.chat_room_id, message: "ラーメン食べたい！" } }
        } .not_to change(ChatPost, :count)
        expect(response).to redirect_to login_path
      end
    end

    context "メッセージの削除" do
      it "メッセージの削除ができずログイン画面にリダイレクトすること" do
        expect {
          delete chat_post_path(message.id)
        }        .not_to change(ChatPost, :count)
        expect(response).to redirect_to login_path
      end
    end
  end

  context "ログインしているが別のユーザーの場合" do
    before do
      login_for_request(third)
    end

    context "メッセージの投稿" do
      it "メッセージの投稿ができずホームにリダイレクトすること" do
        expect {
          post chat_posts_path, params: { chat_post: { chat_room_id: chat_user1.chat_room_id, message: "ラーメン食べたい！" } }
        } .not_to change(ChatPost, :count)
        expect(response).to redirect_to root_url
      end
    end

    context "メッセージの削除" do
      it "メッセージの削除ができずホームにリダイレクトすること" do
        expect {
          delete chat_post_path(message.id)
        }        .not_to change(ChatPost, :count)
        expect(response).to redirect_to root_url
      end
    end
  end
end
