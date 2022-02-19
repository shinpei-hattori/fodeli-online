require 'rails_helper'

RSpec.describe "ユーザー登録", type: :request do
  before do
    get signup_path
  end

  it "正常なレスポンスを返すこと" do
    expect(response).to be_successful
    expect(response).to have_http_status "200"
  end

  context "有効なユーザーで登録" do
    it "ユーザーとメールが１つ作成されること" do
      expect {
        post users_path, params: { user: { name: "Example User",
                                           email: "user@example.com",
                                           password: "password",
                                           password_confirmation: "password" } }
      }.to change(User, :count).by(1).and change { ActionMailer::Base.deliveries.count }.by(1)
    end
    context "有効化の可否" do
      before do
        post users_path, params: { user: { name: "Example User",
                                           email: "user@example.com",
                                           password: "password",
                                           password_confirmation: "password" } }
      end

      it "ユーザー作成直後は有効化されていないこと" do
        user = controller.instance_variable_get('@user')
        expect(user.activated?).not_to be_truthy
      end

      it "有効化されていない状態ではログインできないこと" do
        user = controller.instance_variable_get('@user')
        login_for_request(user)
        expect(is_logged_in?).not_to be_truthy
      end

      it "有効化トークンが不正な場合は、ログインできないこと" do
        user = controller.instance_variable_get('@user')
        get edit_account_activation_path("invalid token", email: user.email)
        expect(is_logged_in?).not_to be_truthy
      end

      it "トークンは正しいがメールアドレスが無効な場合は、ログインできないこと" do
        user = controller.instance_variable_get('@user')
        get edit_account_activation_path(user.activation_token, email: 'wrong')
        expect(is_logged_in?).not_to be_truthy
      end

      it "トークン、アドレスが正しい場合は、有効化されログインし、ユーザーページへリダイレクトされること" do
        user = controller.instance_variable_get('@user')
        get edit_account_activation_path(user.activation_token, email: user.email)
        expect(user.reload.activated?).to be_truthy
        follow_redirect!
        expect(response).to render_template('users/show')
        expect(is_logged_in?).to be_truthy
      end
    end
  end

  it "無効なユーザーで登録ではユーザーが作成されないこと" do
    expect {
      post users_path, params: { user: { name: "",
                                         email: "user@example.com",
                                         password: "password",
                                         password_confirmation: "pass" } }
    }.not_to change(User, :count)
    expect(response).to render_template('users/new')
    expect(is_logged_in?).not_to be_truthy
  end
end
