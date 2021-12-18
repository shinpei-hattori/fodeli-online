require 'rails_helper'

RSpec.describe Company, type: :model do
  let(:company) { create(:company) }

  context "バリデーション" do
    it "有効な状態であること" do
      expect(company).to be_valid
    end

    it "会社名がなければ無効な状態であること" do
      company = build(:company, name: nil)
      company.valid?
      expect(company.errors[:name]).to include("を入力してください")
    end

    it "同じ会社は登録できないこと" do
      create(:company, name: "wolt")
      company = build(:company, name: "wolt")
      company.valid?
      expect(company.errors[:name]).to include("はすでに存在します")
    end
  end
end
