require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:noti) { create(:notification) }

  context "バリデーション" do
    it "有効な状態であること" do
      expect(noti).to be_valid
    end

    it "visitor_id(通知する方)がなければ無効な状態であること" do
      noti = build(:notification, visitor_id: nil)
      noti.valid?
      expect(noti.errors[:visitor_id]).to include("を入力してください")
    end

    it "visited_id(通知される方)がなければ無効な状態であること" do
      noti = build(:notification, visited_id: nil)
      noti.valid?
      expect(noti.errors[:visited_id]).to include("を入力してください")
    end

    it "action(種別)がなければ無効な状態であること" do
      noti = build(:notification, action: nil)
      noti.valid?
      expect(noti.errors[:action]).to include("を入力してください")
    end
  end
end
