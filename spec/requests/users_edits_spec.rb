require 'rails_helper'

RSpec.describe "UsersEdits", type: :request do
  describe "GET /users_edits" do
    before do
      @user = create(:user)
    end
    subject { get edit_user_path(@user) }
    
    
    it "unsuccessful edit" do
      subject
      expect(response).to have_http_status(200)
      expect(subject).to render_template('users/edit')
      patch user_path(@user), params: { user: { name: "",
                                                email: "foo@invalid",
                                                password:              "foo",
                                                password_confirmation: "bar" } }
      expect(subject).to render_template('users/edit')
      assert_select 'div.alert', count: 1
    end
    it "successful edit" do
      subject
      expect(response).to have_http_status(200)
      expect(subject).to render_template('users/edit')
      patch user_path(@user), params: { user: { name:  "Foo Bar",
                                                email: "foo@bar.com",
                                                password:              "foo",
                                                password_confirmation: "foo" } }
      expect(flash).to be_empty
      expect(patch user_path(@user)).to redirect_to @user
      @user.reload
      # expect(name).to eq(@user.name)
      # expect(email).to eq(@user.email)
    end
  end
end
