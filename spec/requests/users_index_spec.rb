require 'rails_helper'
require 'helpers'

RSpec.describe "UsersIndex", type: :request do
  describe "ユーザー一覧のテスト" do
    include Helpers
    before do
      @admin = create(:michael)
      @non_admin = create(:archer)
      @other_user = create_list(:other_users, 30)
    end
    
    it "index で pegination が正しく表示されること" do
      log_in_as(@admin)
      get users_path
      assert_template 'users/index'
      assert_select 'div.pagination', count: 2
      first_page_of_users = User.paginate(page: 1)
      first_page_of_users.each do |user|
        assert_select 'a[href=?]', user_path(user), text: user.name
        unless user == @admin
          assert_select 'a[href=?]', user_path(user), text: "delete"
        end
      end
      expect{ delete user_path(@non_admin) }.to change{ User.count }.by(-1)
    end
    it "admin 無しでの index" do
      log_in_as(@non_admin)
      get users_path
      assert_select 'a', text: 'delete', count: 0
    end
  end
end
