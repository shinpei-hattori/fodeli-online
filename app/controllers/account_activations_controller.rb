class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "アカウントの有効化に成功しました"
      redirect_to user
    else
      flash[:danger] = "アカウントの有効化に失敗しました。または既に有効化されている可能性があります。"
      redirect_to root_url
    end
  end
end
