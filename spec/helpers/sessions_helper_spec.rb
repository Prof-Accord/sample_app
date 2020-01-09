require 'rails_helper'
require 'helpers'

RSpec.describe SessionsHelper, type: :helper do
  include Helpers
  let (:user) { create(:michael) }
  
  it "セッションが nil のとき current_user が正しいユーザーを返すこと" do
    remember(user)
    # assert_equal @user, current_user
    expect(user).to eq current_user
    # assert is_logged_in?
    expect(is_logged_in?).to be_truthy
  end
  
  it "remember digest が間違っているとき current_user が nil を返すこと" do
    user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert current_user == nil
  end
end