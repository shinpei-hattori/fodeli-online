require 'rails_helper'

RSpec.describe Area, type: :model do
  let(:area) { create(:area) }


  context "バリデーション" do
    it "有効な状態であること" do
      expect(area).to be_valid
    end

    it "エリアがなければ無効な状態であること" do
      area = build(:area, city: nil)
      area.valid?
      expect(area.errors[:city]).to include("を入力してください")
    end


    it "同じエリアは登録できないこと" do
      create(:area,city: "さいたま市")
      area = build(:area, city: "さいたま市")
      area.valid?
      expect(area.errors[:city]).to include("はすでに存在します")
    end

  end
end
