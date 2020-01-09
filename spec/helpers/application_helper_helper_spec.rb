require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'ヘルパーが正しく機能すること' do
    it 'full_titleヘルパーのテスト' do
      assert_equal full_title,         "Ruby on Rails Tutorial Sample App"
      assert_equal full_title("Help"), "Help | Ruby on Rails Tutorial Sample App"
    end
  end
end
