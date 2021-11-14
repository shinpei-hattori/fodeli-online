include ApplicationHelper # full_titleメソッドの読み込み

# ログインしているか
def is_logged_in?
  !session[:user_id].nil?
end

# ログイン情報の保持なしで、ログイン
def login_for_request(user)
  post login_path, params: { session: { email: user.email,
                                        password: user.password } }
end

# ログイン情報の保持ありで、ログイン
def login_remember(user)
  post login_path, params: { session: { email: user.email,
                                        password: user.password,
                                        remember_me: '1' } }
end

# ログインしてるユーザー
def current_user
  if (user_id = session[:user_id])
    User.find_by(id: user_id)
  elsif (user_id = cookies.signed[:user_id])
    user = User.find_by(id: user_id)
    if user && user.authenticated?(cookies[:remember_token])
      login_for_request user
      user
    end
  end
end
