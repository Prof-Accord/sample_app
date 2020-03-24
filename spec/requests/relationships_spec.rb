require 'rails_helper'
require 'helpers'

RSpec.describe "Relationships", type: :request do
  describe "GET /relationships" do
    include Helpers
    let(:user_a) { create(:michael, id: 1) }
    let(:user_b) { create(:lana, id: 2) }
    before do
      user_a.follow(user_b)
    end
    it "createアクションはログインしているユーザーが必要なこと" do
      expect {
        post relationships_path
    }.to change { Relationship.count }.by(0)
    expect(response).to redirect_to login_url
    end

    it "deleteアクションはログインしているユーザーが必要なこと" do
      expect {
        delete relationship_path(id: user_a.id, followed_id: user_b.id)
    }.to change { Relationship.count }.by(0)
    end
  end
end