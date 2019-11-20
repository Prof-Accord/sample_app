require 'rails_helper'
require 'helpers'

RSpec.describe "ユーザーログインの結合テスト", type: :request do
  describe "Flashが正しく表示されること" do
    before do
      @user = create(:user)
      @invalid_user = { email: "", password: "" }
    end
    context "無効な情報でのログイン" do
      include Helpers
      it "エラーのFlashが他のページで表示されないこと" do
        get login_path
        expect(response).to have_http_status(200)
        # assert_template 'sessions/new'
        expect(response).to render_template(:new)
        post login_path, params: { session: @invalid_user }
        assert_template 'sessions/new'
        assert flash.any?
        get root_path
        assert flash.empty?
      end
    end
    context "有効な情報でのログイン"  do
      include Helpers
      it "有効な情報によるログインとログアウト" do
        get login_path
        post login_path, params: { session: { email: @user.email,
                                              password: @user.password } }
        assert is_logged_in?
        assert_redirected_to @user
        follow_redirect!
        assert_template 'users/show'
        assert_select "a[href=?]", login_path, count: 0
        assert_select "a[href=?]", logout_path
        assert_select "a[href=?]", user_path(@user)
        delete logout_path
        assert is_logged_in? == false
        assert_redirected_to root_path
        # 2番目のウィンドウでログアウトをクリックするユーザをシミュレートする
        delete logout_path
        follow_redirect!
        assert_select "a[href=?]", login_path, count: 1
        assert_select "a[href=?]", logout_path,       count: 0
        assert_select "a[href=?]", user_path(@user),  count: 0
      end
    end
    describe "remember_meのテスト" do
      include Helpers
      it "記憶しているログイン" do
        log_in_as(@user, remember_me: '1')
        # expect(cookies['remember_token']).not_to be_empty
        assert_equal cookies['remember_token'], assigns(:user).remember_token
      end
      
      it "記憶していないログイン" do
        # クッキーを保存してログイン
        log_in_as(@user, remember_me: '1')
        delete logout_path
        # クッキーを削除してログイン
        log_in_as(@user, remember_me: '0')
        assert_empty cookies['remember_token']
      end
    end
  end
end
