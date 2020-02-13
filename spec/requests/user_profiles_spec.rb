require 'rails_helper'

RSpec.describe "UserProfiles", type: :request do
  describe "ユーザープロフィール" do
    include ApplicationHelper
    let(:user) { create(:michael, email: "test@test.com") }
    before do
      40.times do 
        create(:some_microposts, user: user)
      end
    end
    
    it "プロフィール画面" do
      get user_path(user)
      expect(response).to have_http_status(200)
      expect(response).to render_template 'users/show'
      assert_select 'title', full_title(user.name)
      assert_select 'h1', text: user.name
      assert_select 'h1>img.gravatar'
      expect(response.body).to match  user.microposts.count.to_s
      assert_select 'div.pagination', 1
      user.microposts.paginate(page: 1).each do |micropost|
        expect(response.body).to match micropost.content
      end
    end
  end
end
