require 'rails_helper'

RSpec.describe ChatUser, type: :model do
  let!(:chat_user) { create(:chat_user) }

  context "バリデーション" do
    it "有効な状態であること" do
      expect(chat_user).to be_valid
    end

    it "ユーザーIDがなければ無効な状態であること" do
      user = build(:chat_user, user_id: nil)
      user.valid?
      expect(user.errors[:user_id]).to include("を入力してください")
    end

    it "ルームIDがなければ無効な状態であること" do
      user = build(:chat_user, chat_room_id: nil)
      user.valid?
      expect(user.errors[:chat_room_id]).to include("を入力してください")
    end
  end
end
