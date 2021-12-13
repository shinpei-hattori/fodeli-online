require 'rails_helper'

RSpec.describe "個人チャットのメッセージ", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:no_authority) { create(:user) }
  let!(:room) {create(:dm_room)}
  let!(:entry1) { create(:dm_entry,user:user,dm_room: room) }
  let!(:entry2) { create(:dm_entry,user:other_user,dm_room: room) }
  let!(:message){create(:dm_message,user:user,dm_room: room,message: "ラーメン食べたい")}

  context "ログインしている場合" do
    before do
      login_for_request(user)
    end
    context "メッセージの投稿" do
      it "メッセージの投稿ができること" do
        expect {
          post dm_messages_path, params: { dm_message: {dm_room_id: entry1.dm_room_id,message: "ラーメン食べたい！"}
        }}.to change(DmMessage, :count).by(1)
        expect(response).to redirect_to dm_room_path(entry1.dm_room)
      end

      it "Ajaxによるメッセージの投稿ができること" do
        expect {
          post dm_messages_path, params: { dm_message: {dm_room_id: entry1.dm_room_id,message: "ラーメン食べたい！"}
        }, xhr: true}.to change(DmMessage, :count).by(1)
      end
    end

    context "メッセージの削除" do
      it "メッセージの削除ができること" do
        room = message.dm_room
        expect {
          delete dm_message_path(message.id)}.to change(DmMessage, :count).by(-1)
        expect(response).to redirect_to dm_room_path(room)
      end

      it "Ajaxによるメッセージの削除ができること" do
        room = message.dm_room
        expect {
          delete dm_message_path(message.id), xhr: true}.to change(DmMessage, :count).by(-1)
      end
    end

  end

  context "ログインしていない場合" do

  end
end
