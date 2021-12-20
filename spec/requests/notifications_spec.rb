require 'rails_helper'

RSpec.describe "通知一覧画面", type: :request do
  let(:user) { create(:user) }

  context "ログインしている場合" do
    before do
      login_for_request(user)
      get notifications_path
    end

    it "正常なレスポンスを返すこと" do
      expect(response).to be_successful
      expect(response).to have_http_status "200"
    end
  end

  context "ログインしていない場合" do
    it "ログインページへリダイレクトすること" do
      get notifications_path
      expect(response).to redirect_to login_path
    end
  end
end
