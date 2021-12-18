require 'rails_helper'

RSpec.describe ChatRoom, type: :model do
  let!(:chat_room) { create(:chat_room) }

  context "バリデーション" do
    it "有効な状態であること" do
      expect(chat_room).to be_valid
    end

    it "会社IDがなければ無効な状態であること" do
      room = build(:chat_room, company_id: nil)
      room.valid?
      expect(room.errors[:company_id]).to include("を入力してください")
    end

    it "エリアIDがなければ無効な状態であること" do
      room = build(:chat_room, area_id: nil)
      room.valid?
      expect(room.errors[:area_id]).to include("を入力してください")
    end
  end
end
