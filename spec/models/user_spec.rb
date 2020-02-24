require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:michael) }

  describe "バリデーション" do
    it "userが有効であること" do
      expect(user.valid?).to eq(true)
    end
    it "nameが空白ではないこと" do
      user.name = "    "
      expect(user.valid?).to eq(false)
    end
    it "emailが空白ではないこと" do
      user.email = "    "
      expect(user.valid?).to eq(false)
    end
    it "nameの長さは50文字以内であること" do
      user.name = "a" * 51
      expect(user.valid?).to eq(false)
    end
    it "emailの長さは255文字以内であること" do
      user.email = "a" * 244 + "@example.com"
      expect(user.valid?).to eq(false)
    end
    it "有効なメールアドレスであること" do
      valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                           first.last@foo.jp alice+bob@baz.cn]
      valid_addresses.each do |valid_address|
        user.email = valid_address
        assert user.valid?, "#{valid_address.inspect} should be valid"
      end
    end
    it "メールアドレスのフォーマットが有効であること" do
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                             foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      invalid_addresses.each do |invalid_address|
        user.email = invalid_address
        assert user.invalid?, "#{invalid_address.inspect} should be invalid"
      end
    end
    it "メールアドレスがユニークであること" do
      duplicate_user = user.dup
      duplicate_user.email = user.email.upcase
      user.save
      assert duplicate_user.invalid?
    end
    it "メールアドレスが小文字で保存されること" do
      mixed_case_email = "Foo@ExAMPle.CoM"
      user.email = mixed_case_email
      user.save
      expect(mixed_case_email.downcase).to eq user.reload.email
    end
    it "パスワードが空白でないこと" do
      user.password = user.password_confirmation = "  " * 6
      assert user.invalid?
    end
    it "パスワードが6文字以上であること" do
      user.password = user.password_confirmation = "a" * 5
      assert user.invalid?
    end
    it "ダイジェストが存在しない時にauthenticated?がnilを返すこと" do
      # assert @user.authenticated?(:remember, '') == nil?
      expect(user.authenticated?(:remember, '')).to eq false
    end
    it "関連するマイクロポストが削除されること" do
      user.save
      user.microposts.create!(content: "Lorem ipsum")
      expect{ 
        user.destroy
      }.to change(Micropost, :count).by(-1)
    end

    describe "#follow / #unfollow" do
      let(:other_user) { create(:archer) }
      subject { user.following?(other_user) }
      
      context "フォローしていない場合" do
        it "falseを返すこと" do
          is_expected.to be_falsey
        end
        it "フォローが成功すること" do
          user.follow(other_user)
          is_expected.to be_truthy
        end
      end

      context "フォローしている場合" do
        before do
          user.follow(other_user)
        end
        it "アンフォローが成功すること" do
          user.unfollow(other_user)
          is_expected.to be_falsey
        end
        it "フォロワーに追加されていること" do
          expect(other_user.followers).to include user
        end
      end
    end
  end
end
