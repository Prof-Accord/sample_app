require 'rails_helper'
require 'helpers'
include ApplicationHelper
include SessionsHelper

RSpec.describe "SitieLayouts", type: :request do
  describe "home ページのレイアウト" do
    include Helpers
    let(:user) { create(:michael) }
    
    it "レイアウトのリンクが正常であること" do
      get root_path
      expect(response).to have_http_status(200)
      assert_template 'static_pages/home'
      assert_select "a[href=?]", root_path, count: 2
      assert_select "a[href=?]", help_path
      assert_select "a[href=?]", users_path, count: 0
      assert_select "a[href=?]", about_path
      assert_select "a[href=?]", contact_path
      get contact_path
      assert_select "title", full_title("Contact")
      get signup_path
      assert_select "title", full_title("Sign up")
      log_in_as(user, remember_me: '1')
      get root_path
      assert_select "a[href=?]", users_path, count: 1
      assert_select "a[href=?]", user_path(current_user), count: 3
      assert_select "a[href=?]", edit_user_path(current_user), count: 1
      assert_select "a[href=?]", logout_path, count: 1
    end
  end
end
