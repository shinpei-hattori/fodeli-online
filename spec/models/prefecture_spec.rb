require 'rails_helper'

RSpec.describe Prefecture, type: :model do
  let(:pref) { create(:prefecture) }

  context "バリデーション" do
    it "有効な状態であること" do
      expect(pref).to be_valid
    end

    it "都道府県がなければ無効な状態であること" do
      pref = build(:prefecture, name: nil)
      pref.valid?
      expect(pref.errors[:name]).to include("を入力してください")
    end

    it "同じ都道府県は登録できないこと" do
      create(:prefecture, name: "北海道")
      pref = build(:prefecture, name: "北海道")
      pref.valid?
      expect(pref.errors[:name]).to include("はすでに存在します")
    end
  end
end
