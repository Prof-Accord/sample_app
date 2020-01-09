require 'rails_helper'
require 'helpers'

RSpec.describe "UsersEdits", type: :request do
  describe "GET /users_edits" do
    before do
      @user = create(:michael)
      @other_user = create(:archer)
    end
    subject { get edit_user_path(@user) }
    include Helpers
    
    context "edit" do
      it "editが失敗する場合" do
        log_in_as(@user)
        subject
        expect(response).to have_http_status(200)
        expect(subject).to render_template('users/edit')
        patch user_path(@user), params: { user: { name: "",
                                                  email: "foo@invalid",
                                                  password:              "foo",
                                                  password_confirmation: "bar" } }
        expect(subject).to render_template('users/edit')
        assert_select 'div.alert', count: 1
      end
      it "editが成功する場合" do
        subject
        log_in_as(@user)
        expect(response).to redirect_to edit_user_url(@user)
        name = "Foo Bar"
        email = "foo@bar.com"
        patch user_path(@user), params: { user: { name: name,
                                                  email: email,
                                                  password:              "",
                                                  password_confirmation: "" } }
        expect(flash).not_to be_empty
        expect(response).to redirect_to @user
        @user.reload
        expect(name).to eq(@user.name)
        expect(email).to eq(@user.email)
      end
    end
    it "should redirect edit when not logged in" do
      subject
      expect(flash).not_to be_empty
      expect(response).to redirect_to login_url
    end
    it "should redirect update when not logged in" do
      patch user_path(@user), params: { user: { name: @user.name,
                                               email: @user.email } }
      expect(flash).not_to be_empty
      expect(response).to redirect_to login_url
    end
    it "should redirect edit when logged in as wrong user" do
      log_in_as(@other_user)
      get edit_user_path(@user)
      expect(flash).to be_empty
      expect(response).to redirect_to(root_url)
    end
    it "should redirect update when logged in as wrong user" do
      log_in_as(@other_user)
      patch user_path(@user), params: { user: { name: @user.name,
                                                email: @user.email } }
      expect(flash).to be_empty
      expect(response).to redirect_to(root_url)
    end
    it "フレンドリーフォワーディング" do
      get edit_user_path(@user)
      expect(session[:forwarding_url]).to eq(request.original_url)
      log_in_as(@user)
      expect(response).to redirect_to edit_user_url(@user)
      expect(session[:forwarding_url]).to be_nil
      name = "Foo Bar"
      email = "foo@bar.com"
      patch user_path(@user), params: { user: { name: name,
                                                email: email,
                                                password:              "",
                                                password_confirmation: "" } }
      expect(flash).not_to be_empty
      expect(response).to redirect_to @user
      @user.reload
      expect(name).to eq(@user.name)
      expect(email).to eq(@user.email)
    end
    it "ブラウザから admin 属性を変更できないこと" do
    log_in_as(@other_user)
    expect(@other_user.admin?).to eq(false)
    patch user_path(@other_user), params: {
                                  user:   { password: "password",
                                  password_confirmation: "password",
                                  admin: true } }
    expect(@other_user.reload.admin?).to eq(false)
    end
    context "無効な delete アクションでリダイレクトされること" do
      it "ログインしていないユーザーの場合" do
        expect{ delete user_path(@user) }.to change{ User.count }.by(0)
        expect(response).to redirect_to(login_url)
      end
      it "admin 属性が無いユーザーの場合" do
        log_in_as(@other_user)
        expect{ delete user_path(@user) }.to change{ User.count }.by(0)
        expect(response).to redirect_to root_url
      end
    end
  end
end
