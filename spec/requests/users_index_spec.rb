require 'rails_helper'
require 'helpers'

RSpec.describe "UsersIndex", type: :request do
  describe "ユーザー一覧のテスト" do
    include Helpers
    let(:admin) { create(:michael) }
    let(:non_admin) { create(:archer) }
    let(:non_activate) { create(:lana) }
    let!(:other_users) { create_list(:other_users, 30) }
    let(:first_page_of_users) { User.paginate(page: 1) }
    
    context "indexへのアクセス" do
      it "ログインしていない場合" do
        get users_path
        expect(response).to have_http_status(302)
        expect(response).to redirect_to login_url
      end
      it "ログインしている場合" do
        log_in_as(admin)
        get users_path
        expect(response).to have_http_status(200)
        expect(response).to render_template 'users/index'
      end
    end
    context "indexへのアクセスとpagination" do
      it "admin属性がある場合" do
        log_in_as(admin)
        get users_path
        expect(response).to render_template 'users/index'
        assert_select 'div.pagination', count: 2
        first_page_of_users.each do |user|
          assert_select 'a[href=?]', user_path(user), text: user.name
          # 有効なユーザーだけ表示されていることの確認
          expect(user.activated?).to be_truthy
          unless user == admin
            assert_select 'a[href=?]', user_path(user), text: "delete"
          end
        end
        expect{ delete user_path(admin) }.to change{ User.count }.by(-1)
      end
      it "admin属性がない場合" do
        log_in_as(non_admin)
        get users_path
        expect(response).to render_template 'users/index'
        assert_select 'div.pagination', count: 2
        assert_select 'a', text: 'delete', count: 0
      end
    end
    it "有効でないユーザーのページにアクセスするとリダイレクトされること" do
      # 11.3の演習課題
      log_in_as(admin)
      get user_path(non_activate), params: { id: non_activate.id }
      expect(response).to redirect_to root_url
    end
  end
end
