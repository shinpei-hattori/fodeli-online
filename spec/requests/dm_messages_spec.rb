require 'rails_helper'

RSpec.describe "個人チャットのメッセージ", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:third) { create(:user) }
  let!(:room) { create(:dm_room) }
  let!(:entry1) { create(:dm_entry, user: user, dm_room: room) }
  let!(:entry2) { create(:dm_entry, user: other_user, dm_room: room) }
  let!(:message) { create(:dm_message, user: user, dm_room: room, message: "ラーメン食べたい") }

  context "ログインしている場合" do
    before do
      login_for_request(user)
    end

    context "メッセージの投稿" do
      it "メッセージの投稿ができること" do
        expect {
          post dm_messages_path, params: { dm_message: { dm_room_id: entry1.dm_room_id, message: "ラーメン食べたい！" } }
        } .to change(DmMessage, :count).by(1)
        expect(response).to redirect_to dm_room_path(entry1.dm_room)
      end

      it "Ajaxによるメッセージの投稿ができること" do
        expect {
          post dm_messages_path, params: { dm_message: { dm_room_id: entry1.dm_room_id, message: "ラーメン食べたい！" } }, xhr: true
        } .to change(DmMessage, :count).by(1)
      end
    end

    context "メッセージの削除" do
      it "メッセージの削除ができること" do
        expect {
          delete dm_message_path(message.id)
        }        .to change(DmMessage, :count).by(-1)
        expect(response).to redirect_to dm_room_path(message.dm_room)
      end

      it "Ajaxによるメッセージの削除ができること" do
        expect {
          delete dm_message_path(message.id), xhr: true
        }        .to change(DmMessage, :count).by(-1)
      end
    end
  end

  context "ログインしていない場合" do
    context "メッセージの投稿" do
      it "メッセージの投稿ができずログイン画面にリダイレクトすること" do
        expect {
          post dm_messages_path, params: { dm_message: { dm_room_id: entry1.dm_room_id, message: "ラーメン食べたい！" } }
        } .not_to change(DmMessage, :count)
        expect(response).to redirect_to login_path
      end
    end

    context "メッセージの削除" do
      it "メッセージの削除ができずログイン画面にリダイレクトすること" do
        expect {
          delete dm_message_path(message.id)
        }        .not_to change(DmMessage, :count)
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
          post dm_messages_path, params: { dm_message: { dm_room_id: entry1.dm_room_id, message: "ラーメン食べたい！" } }
        } .not_to change(DmMessage, :count)
        expect(response).to redirect_to root_url
      end
    end

    context "メッセージの削除" do
      it "メッセージの削除ができずホームにリダイレクトすること" do
        expect {
          delete dm_message_path(message.id)
        }        .not_to change(DmMessage, :count)
        expect(response).to redirect_to root_url
      end
    end
  end
end
