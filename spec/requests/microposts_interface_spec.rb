require 'rails_helper'
require 'helpers'

RSpec.describe "MicropostsInterface", type: :request do
  include Helpers
  let(:user_a) { create(:michael, email: "test@test.com") }
  let(:user_b) { create(:archer) }
  let(:user_c) { create(:lana, activated: true) }
  let(:user_c_micropost) { create(:some_microposts, user: user_c) }
  let(:content) { content = "This micropost really ties the room together" }
  before do
    40.times { create(:some_microposts, user: user_a) }
    create(:some_microposts, user: user_b)
  end
  
  describe "micropostの統合テスト" do
    before do
      log_in_as(user_a)
      get root_path
      assert_select 'div.pagination'
    end
    it "無効な送信" do
      expect{
        post microposts_path, params: { micropost: { content: "" } }
      }.to change{ Micropost.count }.by(0)
    end
    it "有効な送信" do
      expect{
        post microposts_path, params: { micropost: { content: content } }
      }.to change { Micropost.count }.by(1)
      expect(response).to redirect_to root_url
      follow_redirect!
      expect(response.body).to match content
    end
    it "投稿を削除する" do
      assert_select 'a', text: 'delete'
      first_micropost = user_a.microposts.paginate(page: 1).first
      expect{
        delete micropost_path(first_micropost)
      }.to change{ Micropost.count }.by(-1)
    end
    it "別のユーザーのプロフィールにアクセス(deleteリンクが無いことを確認)" do
      get user_path(user_b)
      assert_select 'a', text: 'delete', count: 0
    end
  end
  
  describe "サイドバーのマイクロポストのカウント" do
    context "マイクロポストが2以上のとき" do
      it "複数形であること" do
        log_in_as(user_a)
        get root_path
        expect(response.body).to match "#{user_a.microposts.count} microposts"
      end
    end
    context "マイクロポストが1のとき" do
      it "1 micropostであること" do
        log_in_as(user_c)
        user_c.microposts.create!(content: "A micropost")
        get root_path
        expect(response.body).to match "1 micropost"
      end
    end
    context "マイクロポストが0のとき" do
      it "0 micropostsであること" do
        log_in_as(user_c)
        get root_path
        expect(response.body).to match "0 microposts"
      end
    end
  end
  describe "画像アップロードのテスト" do
    before do
      log_in_as(user_a)
      get root_path
      assert_select 'input[type="submit"]'
    end
    
    it "画像アップロードが成功すること" do
      picture = fixture_file_upload('spec/fixtures/PNG_accord.png', 'image/png')
      expect{
        post microposts_path, params: { micropost:
                                        { content: content,
                                          picture: picture } }
      }.to change{ Micropost.count }.by(1)
      expect(assigns(:micropost).picture?).to be_truthy
    end
  end
end
