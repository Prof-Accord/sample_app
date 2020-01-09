require 'rails_helper'
require 'helpers'

RSpec.describe "UsersController", type: :request do
  let(:user) { create(:michael) }
  let(:other_user) { create(:archer) }
  
  describe "GET #new" do
    it "new にアクセスできること" do
      get signup_path
      expect(response).to have_http_status 200
    end
    
    describe "deleteアクションのテスト" do
      it "ログインしていないとき、deleteでログイン画面にリダイレクトされること" do
        delete user_path(user), params: { id: user.id }
        expect(response).to redirect_to login_path
      end
    end
  end
end
