require 'rails_helper'

RSpec.describe "ChatMessages", type: :system do
  let!(:user) { create(:user) }
  let!(:second) { create(:user) }

  describe "エリア別チャットページ" do
    before do
      @pref = [
            '---' , '北海道' ,'青森県' ,'岩手県' , '宮城県' ,  '秋田県' ,
            '山形県' , '福島県' , '茨城県' ,'栃木県' , '群馬県' , '埼玉県' ,
            '千葉県' , '東京都' ,  '神奈川県' ,'新潟県' , '富山県' , '石川県' ,
            '福井県' , '山梨県' , '長野県' ,'岐阜県' ,'静岡県' , '愛知県' ,
            '三重県' , '滋賀県' ,  '京都府' ,'大阪府' , '兵庫県' ,'奈良県' ,
            '和歌山県','鳥取県' , '島根県' ,'岡山県' ,  '広島県' ,  '山口県' ,
            '徳島県' , '香川県' , '愛媛県' ,'高知県' , '福岡県' ,'佐賀県' ,
            '長崎県' , '熊本県' , '大分県' ,'宮崎県' , '鹿児島県' ,'沖縄県'
          ]
      @pref.each { |n| create(:prefecture,name: n)}
      pref = Prefecture.find_by(name: '北海道').id
      area = create(:area,city: "旭川市", prefecture_id: pref)
      company = ["Uber Eats","出前館","DiDi Food","menu","Chompy","Wolt","foodpanda","DOORDASH"]
      company.each {|c| Company.create!(name: c)}
      company = Company.find_by(name: "出前館").id
      @room = create(:chat_room,company_id: company, area: area)
      create(:chat_user,user: user,chat_room: @room)
      create(:chat_user,user: second,chat_room: @room)
    end

    context "チャット検索画面" do
      before do
        login_for_system(user)
        visit chat_rooms_path
      end
      it "正しいレイアウトが表示されていること" do
        @pref.each do |n|
          unless n == '---'
            expect(page).to have_button n
          end
        end
        expect(page).to have_title full_title("チャット検索")
        expect(page).to have_content "会社を選んでください"
        expect(page).to have_content "エリアを選んでください"
        expect(page).to have_select('company',options: ["Uber Eats","出前館","DiDi Food","menu","Chompy","Wolt","foodpanda","DOORDASH"])
      end


      it "検索したエリアと会社名とタイトルと参加者のリンクが正常に表示されていること" , js: true do
        select '出前館', from: '会社を選んでください'
        find("#hokkaido").click
        find("#tanaka").click
        expect(page).to have_content "旭川市のチャット"
        expect(page).to have_content "出前館"
        expect(page).to have_title "旭川市のチャット"
        expect(page).to have_link '', href: user_path(user)
        expect(page).to have_link '', href: user_path(second)
      end
    end

    context "チャットメッセージ入力画面" do
      before do
        login_for_system(user)
        visit chat_room_path(@room)
      end
      context "ルーム退出処理" do
        it "退出リンクがあること" do
          expect(page).to have_link "退出" , href: chat_room_path(@room)
        end

        it "退出をクリックするとホーム画面にリダイレクトされること" do
          click_link "退出"
          expect(page).to have_content "ルームを退出しました"
          expect(page).to have_title full_title
          expect(page).to have_content "みんなのツイート"
        end
      end

      context "メッセージの投稿" do
        it "投稿ができ、削除リンクが表示されること" do
          fill_in 'chat_post[message]',with: '今年は寒いですな'
          click_on '投稿'
          expect(page).to have_content '今年は寒いですな'
          expect(page).to have_link '削除',href: chat_post_path(ChatPost.last)
        end

        it "他人の投稿も表示されるが、削除リンクは表示されないこと" do
          create(:chat_post,user: second,chat_room: @room,message: "たしかに寒いですね")
          visit chat_room_path(@room)
          expect(page).to have_content 'たしかに寒いですね'
          expect(page).not_to have_link '削除',href: chat_post_path(ChatPost.last)
        end
      end

      context "メッセージの削除",js: true do
        it "削除したメッセージは表示されないこと" do
          create(:chat_post,user: user,chat_room: @room,message: "カレー食べたい")
          create(:chat_post,user: second,chat_room: @room,message: "お寿司食べたい")
          visit chat_room_path(@room)
          click_link "削除"
          page.driver.browser.switch_to.alert.accept
          expect(page).to have_content 'お寿司食べたい'
          expect(page).not_to have_content 'カレー食べたい'
        end
      end
    end

    context "参加チャット画面" do
      before do
        login_for_system(user)
        visit chatlists_user_path(user)
      end

      it "正しいレイアウトが表示されていること" do
        expect(page).to have_title full_title("参加中チャット")
        expect(page).to have_content "参加中チャット"
        expect(page).to have_content @room.company.name
        expect(page).to have_content @room.area.city
        expect(page).to have_link "退出" , href: chat_room_path(@room)
      end

      it "退出をクリックすると参加チャットからルームが表示されなくなること" do
        click_link "退出"
        expect(page).to have_content "ルームを退出しました"
        expect(page).not_to have_content @room.company.name
        expect(page).not_to have_content @room.area.city
        expect(page).not_to have_link "退出" , href: chat_room_path(@room)
      end

    end

  end
end
