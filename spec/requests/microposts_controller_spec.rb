require 'rails_helper'
require 'helpers'

RSpec.describe MicropostsController, type: :request do
  include Helpers
  let(:user_a) { create(:michael) }
  let(:user_b) { create(:archer) }
  let!(:orange) { create(:orange, user: user_a) }
  let!(:ants) { create(:ants, user: user_b) }
  
  describe "Micropost_Controller" do
    it "ログインせずにcreateするとredirectすること" do
      expect{
        post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
      }.to change{ Micropost.count }.by(0)
      expect(response).to redirect_to login_url
    end
    it "ログインせずにdestroyするとredirectすること" do
      expect{
        delete micropost_path(orange)
      }.to change{ Micropost.count }.by(0)
      expect(response).to redirect_to login_url
    end
  end
    
  describe "#delete" do
    before do
      log_in_as(user_a)
    end
    context "正しいユーザーの場合" do
      it "micropostが削除されること" do
        expect{ delete micropost_path(orange) }.to change{ Micropost.count }.by(-1)
      end
    end
    context "間違ったユーザーの場合" do
      it "micropostの削除に失敗すること" do
        expect{ delete micropost_path(ants) }.to change{ Micropost.count }.by(0)
      end
    end
  end
end