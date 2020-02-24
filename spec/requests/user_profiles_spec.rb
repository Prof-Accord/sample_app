require 'rails_helper'

RSpec.describe "UserProfiles", type: :request do
  describe "ユーザープロフィール" do
    include ApplicationHelper
    let(:user) { create(:michael, email: "test@test.com") }
    let!(:users) { create_list(:other_users, 40) }
    let(:following) { users[1..20] }
    let(:followers) { users[2..31] }
    before do
      40.times{ create(:some_microposts, user: user) }
      following.each { |followed| user.follow(followed) }
      followers.each { |follower| follower.follow(user) }
    end
    
    it "プロフィール画面" do
      get user_path(user)
      assert_select 'title', full_title(user.name)
      assert_select 'h1', text: user.name
      assert_select 'h1>img.gravatar'
      expect(response.body).to match  user.microposts.count.to_s
      assert_select 'div.pagination', 1
      user.microposts.paginate(page: 1).each do |micropost|
        expect(response.body).to match micropost.content
      end
    end

    it "統計情報" do
      get user_path(user)
      assert_select "strong#following", text: "20"
      assert_select "strong#followers", text: "30"
    end
  end
end
