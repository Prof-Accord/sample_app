require 'rails_helper'
require 'helpers'

RSpec.describe "FollowingTest", type: :request do
  include Helpers
  let(:user_a) { create(:michael) }
  let(:user_b) { create(:archer) }
  let(:user_c) { create(:lana) }
  let(:user_d) { create(:malory) }
  before do
    [user_c, user_d].each{ |following| user_a.follow(following) }
    [user_b, user_c].each{ |followers| followers.follow(user_a) }
    log_in_as(user_a)
  end
  
  describe "Followingページ" do
    before do
      get following_user_path(user_a)
    end

    it "followingページ" do
      expect(response.body).to match user_a.following.count.to_s
    end
    it "followingのURLが正しいこと" do
      expect(user_a.following).not_to be_empty
      user_a.following.each do |user|
        assert_select "a[href=?]", user_path(user)
      end
    end
  end
  
  describe "Followersページ" do
    before do
      get followers_user_path(user_a)
    end

    it "follwersページ" do
      expect(response.body).to match user_a.followers.count.to_s
    end
    it "FollowersのURLが正しいこと" do
      expect(user_a.followers).not_to be_empty
      user_a.followers.each do |user|
        assert_select "a[href=?]", user_path(user)
      end
    end
  end
end