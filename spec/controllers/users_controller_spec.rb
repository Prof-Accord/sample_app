require 'rails_helper'
require 'helpers'
RSpec.describe UsersController, type: :controller do
  describe "GET #new" do
    def setup
      @user = create(:michael)
      @other_user = create(:archer)
    end
    render_views
    include Helpers
    
    it "new にアクセスできること" do
      get :new
      expect(response).to have_http_status(:success)
    end
    it "ログインしていない時 index にリダイレクトされること" do
      get :index
      expect(response).to redirect_to login_url
    end
    context "delete アクションのテスト" do
      it "ログインしていないとき、ログイン画面にリダイレクトされること" do
        expect{ delete user_path(@user) }.to change{ User.count }.by(0)
        expect(response).to redirect_to(login_url)
      end
    end
  end
end
