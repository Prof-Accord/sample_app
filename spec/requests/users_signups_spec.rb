require 'rails_helper'

RSpec.describe "ユーザー登録", type: :request do
  describe "ユーザー登録" do
    it "無効なユーザーが登録できないこと" do
      get signup_path
      expect do
        post signup_path, params: {user: { name:  "",
                                   email: "user@invalid",
                                   password:              "foo",
                                   password_confirmation: "bar" } }
      end.to change(User, :count).by(0)
      assert_template 'users/new'
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
      follow_redirect!
      assert_template 'users/show'
      expect(flash).not_to be_empty 
    end
  end
end
