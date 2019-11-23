require 'rails_helper'

RSpec.describe "Users", type: :system do
  before do
    @user = build(:user)
  end
  it "unsuccessful edit" do
    visit edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }

    assert_template 'users/edit'
  end
end