require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let!(:user) { create(:user, name: "佐藤 健", email: "takeru@gmail.com") }

  describe "アカウント有効化メール" do
    let(:mail) { UserMailer.account_activation(user) }

    it "メールのヘッダー情報が設定されていること" do
      expect(mail.subject).to eq("アカウント有効化")
      expect(mail.to).to eq(["takeru@gmail.com"])
      expect(mail.from).to eq(["fodelionline@gmail.com"])
    end

    it "メールの中身とURLパラメータが確認できること" do
      expect(mail.html_part.body.encoded).to match user.name
      expect(mail.html_part.body.encoded).to match user.activation_token
      expect(mail.html_part.body.encoded).to match CGI.escape(user.email)
      expect(mail.text_part.body.encoded).to match user.name
      expect(mail.text_part.body.encoded).to match user.activation_token
      expect(mail.text_part.body.encoded).to match CGI.escape(user.email)
    end
  end

  describe "パスワード再設定メール" do
    let(:mail) { UserMailer.password_reset(user) }

    before do
      user.reset_token = User.new_token
    end

    it "メールのヘッダー情報が設定されていること" do
      expect(mail.subject).to eq("パスワード再設定")
      expect(mail.to).to eq(["takeru@gmail.com"])
      expect(mail.from).to eq(["fodelionline@gmail.com"])
    end

    it "URLパラメータが確認できること" do
      expect(mail.html_part.body.encoded).to match user.reset_token
      expect(mail.html_part.body.encoded).to match CGI.escape(user.email)
      expect(mail.text_part.body.encoded).to match user.reset_token
      expect(mail.text_part.body.encoded).to match CGI.escape(user.email)
    end
  end
end
