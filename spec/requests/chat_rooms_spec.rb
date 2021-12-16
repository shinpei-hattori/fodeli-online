require 'rails_helper'

RSpec.describe "ChatRooms", type: :request do
  let!(:user) { create(:user) }
  let!(:chat_room) { create(:chat_room,company: company,area: area) }
  let!(:company) { create(:company) }
  let!(:area) { create(:area) }

  describe "Createアクション" do
    context "ログインしていない時" do
      before do
        create(:company,name: "wolt")
        create(:area,city: "さいたま市")
      end
      it "ルームは作成されずログイン画面にリダイレクトされること" do
        expect {
          post chat_rooms_path, params: { city: "さいたま市",company: "wolt"}
        }.not_to change(ChatRoom, :count)
        expect(response).to redirect_to login_path
      end
    end

    context "ログインしている時" do
      before do
        login_for_request(user)
        create(:company,name: "uver")
        create(:area,city: "上尾市")
      end
      it "ルームとチャットユーザーが作成されること" do
        expect {
          post chat_rooms_path, params: { city: "上尾市",company: "uver"}
        }.to change(ChatRoom, :count).by(1).and change(ChatUser, :count).by(1)
        follow_redirect!
        expect(response).to render_template('chat_rooms/show')
      end

      it "ルームが既に作成されていればチャットユーザーは作成され、ルームは作成されないこと" do
        # company = Company.find_by(id: chat_room.company_id).name
        # city = Area.find_by(id: chat_room.company_id).city
        # debugger
        expect {
          post chat_rooms_path, params: { city: area.city,company: company.name}
        }.to change(ChatUser, :count).by(1)
        expect {
          post chat_rooms_path, params: { city: area.city,company: company.name}
        }.not_to change(ChatRoom, :count)
      end

      it "ルームもチャットユーザーも作成済みならば、なにも作成されないこと" do
        create(:chat_user,user: user,chat_room: chat_room)
        expect {
          post chat_rooms_path, params: { city: area.city,company: company.name}
        }.not_to change(ChatUser, :count)
        expect {
          post chat_rooms_path, params: { city: area.city,company: company.name}
        }.not_to change(ChatRoom, :count)
      end
    end
  end

  describe "Showアクション" do

    context "ログインしていない時" do
      it "ログイン画面にリダイレクトされること" do
        get chat_room_path(chat_room)
        expect(response).to redirect_to login_path
      end
    end

    context "ログインしている時" do
      before do
        login_for_request(user)
      end
      context "チャットユーザーの有無" do
        it "作成済みならばチャットページに移ること" do
          create(:chat_user,user: user,chat_room:chat_room)
          get chat_room_path(chat_room)
          expect(response).to render_template('chat_rooms/show')
        end
        it "作成していなければホームに戻ること" do
          # create(:chat_user,user: user,chat_room:chat_room)
          get chat_room_path(chat_room)
          follow_redirect!
          expect(response).to render_template('static_pages/home')
        end
      end
    end
  end

end
