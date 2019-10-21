require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ApplicationHelperHelper. For example:
#
# describe ApplicationHelperHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, type: :helper do
  describe 'ヘルパーが正しく機能すること' do
    it 'full_titleヘルパーのテスト' do
      assert_equal full_title,         "Ruby on Rails Tutorial Sample App"
      assert_equal full_title("Help"), "Help | Ruby on Rails Tutorial Sample App"
    end
  end
end
