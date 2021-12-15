require 'rails_helper'

RSpec.describe DmEntrie, type: :model do
  let!(:entry) { create(:dm_entry) }

  context "バリデーション" do
    it "有効な状態であること" do
      expect(entry).to be_valid
    end

    it "ユーザーIDがなければ無効な状態であること" do
      entry = build(:dm_entry, user_id: nil)
      entry.valid?
      expect(entry.errors[:user_id]).to include("を入力してください")
    end

    it "ルームIDがなければ無効な状態であること" do
      entry = build(:dm_entry, dm_room_id: nil)
      entry.valid?
      expect(entry.errors[:dm_room_id]).to include("を入力してください")
    end
  end
end
