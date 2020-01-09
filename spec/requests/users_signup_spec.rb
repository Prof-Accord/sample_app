require 'rails_helper'
require 'helpers'

RSpec.describe "UsersSignup", type: :request do
  describe "ユーザー登録" do
    before do
      ActionMailer::Base.deliveries.clear
    end
    
    context "ユーザーの新規登録" do
      include Helpers
      it "無効なユーザーの場合" do
        get signup_path
        expect do
          post signup_path, params: {user: { name:  "",
                                     email: "user@invalid",
                                     password:              "foo",
                                     password_confirmation: "bar" } }
        end.to change(User, :count).by(0)
        expect(response).to render_template 'users/new'
        assert_select 'form[action="/signup"]'
        assert_select "div#error_explanation", count: 1
        assert_select "div.alert-danger", count: 1
        assert_select 'li', "Name can't be blank"
        assert_select 'li', "Email is invalid"
        assert_select 'li', "Password is too short (minimum is 6 characters)"
      end
        
      it "有効なユーザーの登録" do
        get signup_path
        expect do
          post users_path, params: { user: { name: "Example User",
                                             email: "user@example.com",
                                             password:              "password",
                                             password_confirmation: "password" } }
        end.to change(User, :count).by(1)
        expect(ActionMailer::Base.deliveries.size).to eq(1)
        user = assigns(:user)
        expect(user.activated?).to be_falsey
        log_in_as(user)
        expect(is_logged_in?).to be_falsey
        get edit_account_activation_path("invalid token", email: user.email)
        expect(is_logged_in?).to be_falsey
        get edit_account_activation_path(user.activation_token, email: 'wrong')
        expect(is_logged_in?).to be_falsey
        get edit_account_activation_path(user.activation_token, email: user.email)
        expect(user.reload.activated?).to be_truthy
        follow_redirect!
        expect(response).to render_template 'users/show'
        expect(flash).not_to be_empty
        expect(is_logged_in?).to be_truthy 
      end
    end
  end
end