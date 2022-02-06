class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "パスワード再設定用のメールを送信しました。メールを確認し再設定を行ってください。"
      redirect_to root_url
    else
      flash[:danger] = "このメールアドレスは登録されていません"
      redirect_to new_password_reset_path
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?                  # (3) への対応
      @user.errors.add(:password, :blank)
      flash[:danger] = @user.errors.full_messages
      redirect_to edit_password_reset_url(params[:id],email: params[:email])
    elsif @user.update_attributes(user_params)          # (4) への対応
      log_in @user
      flash[:success] = "パスワードを更新しました！"
      redirect_to @user
    else
      flash[:danger] = @user.errors.full_messages
      redirect_to edit_password_reset_url(params[:id],email: params[:email])  # (2) への対応
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # 正しいユーザーかどうか確認する
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        flash[:danger] = "認証に失敗しました。再度パスワード再設定を申請してください。"
        redirect_to new_password_reset_path
      end
    end

    # トークンが期限切れかどうか確認する
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "パスワード再設定の有効期限が切れています。再度申請をしてください。"
        redirect_to new_password_reset_url
      end
    end
end
