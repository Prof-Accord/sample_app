module Helpers
  # テストユーザがログイン中の場合にtrueを返す
  def is_logged_in?
    !session[:user_id].nil?
  end

  # # テストユーザとしてログインする
  # def log_in_as(user)
  #   session[:user_id] = user.id
  # end
  
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                        password: password,
                                        remember_me: remember_me } }
  end
end

