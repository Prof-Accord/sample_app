require 'rails_helper'
require 'helpers'

RSpec.describe "PasswordResets", type: :request do
  describe  "パスワード再設定のテスト" do
    include Helpers
    let(:user) { create(:michael) }
    before do
      get new_password_reset_path
    end
    
    it "パスワード再設定" do
      # メールアドレスが無効
      expect(response).to render_template 'password_resets/new'
      post password_resets_path, params: { password_reset: { email: "" } }
      expect(flash.empty?).to be_falsey
      expect(response).to render_template 'password_resets/new'
      # メールアドレスが有効
      post password_resets_path,
        params: { password_reset: { email: user.email } }
      expect(user.reset_digest).not_to eq user.reload.reset_digest
      expect(ActionMailer::Base.deliveries.size).to eq 1
      expect(flash.empty?).to be_falsey
      expect(response).to redirect_to root_url
    end
    it "再設定フォーム" do
      post password_resets_path,
        params: { password_reset: { email: user.email } }
      user = assigns(:user)
      # メールアドレスが無効
      get edit_password_reset_path(user.reset_token, email: "")
      expect(response).to redirect_to root_url
      # 無効なユーザー
      user.toggle!(:activated)
      get edit_password_reset_path(user.reset_token, email: user.email)
      expect(response).to redirect_to root_url
      user.toggle!(:activated)
      # メールアドレスが有効で、トークンが無効
      get edit_password_reset_path('wrong token', email: user.email)
      expect(response).to redirect_to root_url
      # メールアドレスもトークンも有効
      get edit_password_reset_path(user.reset_token, email: user.email)
      expect(response).to render_template 'password_resets/edit'
      assert_select "input[name=email][type=hidden][value=?]", user.email
      # 無効なパスワードとパスワード確認
      patch password_reset_path(user.reset_token),
            params: { email: user.email,
                      user: { password:               "foobaz",
                              password_confirmation:  "barquux" } }
      assert_select 'div#error_explanation'
      # パスワードが空
      patch password_reset_path(user.reset_token),
            params: { email: user.email,
                      user: { password:                 "",
                              password_confirmation:    "" } }
      # 有効なパスワードとパスワード確認
      patch password_reset_path(user.reset_token),
            params: { email: user.email,
                      user: { password:                 "foobaz",
                              password_confirmation:    "foobaz" } }
      expect(is_logged_in?).to be_truthy
      expect(flash).not_to be_empty
      expect(response).to redirect_to user
      expect(user.reload.reset_digest).to eq nil
    end
    it "期限切れのトークン" do
      get new_password_reset_path
      post password_resets_path,
           params: { password_reset: { email: user.email } }
      user = assigns(:user)
      user.update_attribute(:reset_sent_at, 3.hours.ago)
      patch password_reset_path(user.reset_token),
            params: { email: user.email,
                      user: { password:               "foobar",
                              password_confirmation:  "foobar" } }
      expect(response).to have_http_status "302"
      follow_redirect!
      expect(response.body).to match /expired/i
    end
  end
end