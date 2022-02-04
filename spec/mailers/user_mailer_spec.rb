require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let!(:user) { create(:user,name: "佐藤 健",email: "takeru@gmail.com") }

  describe "アカウント有効化メール" do
    let(:mail) { UserMailer.account_activation(user) }

    it "メールのヘッダー情報が設定されていること" do
      expect(mail.subject).to eq("アカウント有効化")
      expect(mail.to).to eq(["takeru@gmail.com"])
      expect(mail.from).to eq(["fodelionline@gmail.com"])
    end

    it "メールの情報に期待する値があること" do
      expect(mail.html_part.body.encoded).to match user.name
      expect(mail.html_part.body.encoded).to match user.activation_token
      expect(mail.html_part.body.encoded).to match CGI.escape(user.email)
      expect(mail.text_part.body.encoded).to match user.name
      expect(mail.text_part.body.encoded).to match user.activation_token
      expect(mail.text_part.body.encoded).to match CGI.escape(user.email)
    end
  end

  # describe "password_reset" do
  #   let(:mail) { UserMailer.password_reset }

  #   it "renders the headers" do
  #     expect(mail.subject).to eq("Password reset")
  #     expect(mail.to).to eq(["to@example.org"])
  #     expect(mail.from).to eq(["from@example.com"])
  #   end

  #   it "renders the body" do
  #     expect(mail.body.encoded).to match("Hi")
  #   end
  # end

end
