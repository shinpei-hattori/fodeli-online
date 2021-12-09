require 'rails_helper'

RSpec.describe "個人チャット機能", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:no_authority) { create(:user) }
  let!(:room) {create(:dm_room)}
  let!(:entry1) { create(:dm_entry,user:user,dm_room: room) }
  let!(:entry2) { create(:dm_entry,user:other_user,dm_room: room) }

  context "ログインしている場合" do
    before do
      login_for_request(user)
    end
    it "自身と相手のエントリーデータとルームが作成され、作成したルームのページへリダイレクトすること" do
      expect {
        post dm_rooms_path, params: { dm_room: {dm_entrie: {user_id: other_user.id}}}
      }.to change(DmEntrie, :count).by(2).and change(DmRoom, :count).by(1)
      room = controller.instance_variable_get('@room')
      expect(response).to redirect_to dm_room_path(room)
    end

    context "作成したルームへアクセス" do
      it "正常なレスポンスを返すこと" do
        get dm_room_path(room)
        expect(response).to be_successful
        expect(response).to have_http_status "200"
      end
    end
  end

  context "ログインしているがエントリーユーザーではない場合" do
    before do
      login_for_request(no_authority)
    end
      it "ルートページへリダイレクトされフラッシュが表示されること" do
        get dm_room_path(room)
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to be_truthy
      end

  end

  context "ログインしていない場合" do
    it "createアクションは実行できず、ログインページへリダイレクトすること" do
      expect {
        post dm_rooms_path
      }.not_to change(DmRoom, :count)
      expect(response).to redirect_to login_path
    end

    it "dm_rooms/showページへ飛ぶとログインページへリダイレクトすること" do
      get dm_room_path(room)
      expect(response).to redirect_to login_path
    end
  end

end
