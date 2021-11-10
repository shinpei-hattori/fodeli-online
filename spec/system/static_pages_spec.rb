require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  describe "トップページ" do
    context "ページ全体" do
      before do
        visit root_path
      end

      it "該当の文字列が存在することを確認" do
        expect(page).to have_content 'Fodeli Onlineとは？'
      end

      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title
      end
    end
  end

  describe "aboutページ" do
    before do
      visit about_path
    end

    it "該当の文字列が存在することを確認" do
      expect(page).to have_content 'Foldeli Onlineの使い方'
    end

    it "正しいタイトルが表示されることを確認" do
      expect(page).to have_title full_title('使い方')
    end
  end
end
