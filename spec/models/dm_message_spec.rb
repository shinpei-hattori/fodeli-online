require 'rails_helper'

RSpec.describe DmMessage, type: :model do
  let!(:message) { create(:dm_message) }

  context "バリデーション" do
    it "有効な状態であること" do
      expect(message).to be_valid
    end

    it "ユーザーIDがなければ無効な状態であること" do
      message = build(:dm_message, user_id: nil)
      message.valid?
      expect(message.errors[:user_id]).to include("を入力してください")
    end

    it "ルームIDがなければ無効な状態であること" do
      message = build(:dm_message, dm_room_id: nil)
      message.valid?
      expect(message.errors[:dm_room_id]).to include("を入力してください")
    end

    it "空のメッセージは無効な状態であること" do
      message = build(:dm_message, message: "")
      message.valid?
      expect(message.errors[:message]).to include("を入力してください")
    end

    it "51文字以上のメッセージは無効な状態こと" do
      message = build(:dm_message, message: "a" * 51)
      message.valid?
      expect(message.errors[:message]).to include("は50文字以内で入力してください")
    end
  end
end
