class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash.now[:danger] = 'メールアドレスとパスワードの組み合わせが誤っています'
      render 'new'
    end
  end

  def destroy
    # ログインしていた場合のみログアウト処理。ブラウザ２つで同時にログアウトした場合に起きるバグ対策。
    log_out if logged_in?
    redirect_to root_url
  end
end
