require 'rails_helper'
require 'helpers'

RSpec.describe SessionsHelper, type: :helper do
  include Helpers
  before do
    @user = build(:user)
    remember(@user)
  end
  
  it "セッションが nil のとき current_user が正しいユーザーを返すこと" do
    assert_equal @user, current_user
    assert is_logged_in?
  end
  
  it "remember digest が間違っているとき current_user が nil を返すこと" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert current_user == nil
  end
end