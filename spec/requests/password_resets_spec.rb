require 'rails_helper'

RSpec.describe "パスワード再設定", type: :request do
  let!(:user) { create(:user) }
  describe "メールアドレスが有効化かどうか" do
    before do
      get new_password_reset_path
    end

    it "メールアドレスが無効の場合は、失敗のフラッシュが表示されメールが送られないこと" do
      expect {
        post password_resets_path, params: { password_reset: { email: "" } }
      }.not_to change{ ActionMailer::Base.deliveries.count }
      expect(flash.empty?).not_to be_truthy
      expect(response).to redirect_to new_password_reset_path
    end

    it "メールアドレスが有効の場合は、成功のフラッシュが表示されメールが送信されること" do
      expect {
        post password_resets_path, params: { password_reset: { email: user.email } }
      }.to change{ ActionMailer::Base.deliveries.count }.by(1)
      expect(flash.empty?).not_to be_truthy
      expect(response).to redirect_to root_path
    end
  end

  describe "パスワード更新処理" do
    before do
      post password_resets_path, params: { password_reset: { email: user.email } }
    end
    context "パスワード編集画面を表示してよいか" do
      it "メールアドレスが無効の場合は、メールアドレス入力画面にリダイレクトすること" do
        user = controller.instance_variable_get('@user')
        get edit_password_reset_path(user.reset_token, email: "")
        expect(response).to redirect_to new_password_reset_path
      end

      it "有効化されていないユーザーの場合はメールアドレス入力画面にリダイレクトすること" do
        user.toggle!(:activated)
        user = controller.instance_variable_get('@user')
        get edit_password_reset_path(user.reset_token, email: user.email)
        expect(response).to redirect_to new_password_reset_path
        user.toggle!(:activated)
      end

      it "メールアドレスが有効で、トークンが無効の場合はメールアドレス入力画面にリダイレクトすること" do
        user = controller.instance_variable_get('@user')
        get edit_password_reset_path('wrong token', email: user.email)
        expect(response).to redirect_to new_password_reset_path
      end

      it "メールアドレスもトークンも有効の場合はフォームが表示されること" do
        user = controller.instance_variable_get('@user')
        get edit_password_reset_path(user.reset_token, email: user.email)
        expect(response).to render_template('password_resets/edit')
      end
    end

    context "パスワード更新" do
      it "無効なパスワードとパスワード確認の場合は、フォームへリダイレクトされること" do
        user = controller.instance_variable_get('@user')
        patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "barquux" } }
        expect(response).to redirect_to edit_password_reset_url(user.reset_token,email: user.email)
      end

      it "パスワードが空の場合は、フォームへリダイレクトされること" do
        user = controller.instance_variable_get('@user')
        patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "",
                            password_confirmation: "" } }
        expect(response).to redirect_to edit_password_reset_url(user.reset_token,email: user.email)
      end

      it "有効なパスワードとパスワード確認の場合は、ログインされユーザー詳細ページへリダイレクトされること" do
        user = controller.instance_variable_get('@user')
        patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "foobaz" } }
        expect(response).to redirect_to user
        expect(is_logged_in?).to be_truthy
      end
    end

  end



end
