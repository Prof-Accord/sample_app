FactoryBot.define do
  factory :user do
    name { "hoge" }
    email { "foo@bar.com" }
    password { "foobar" }
    password_confirmation { "foobar" }
    # sequence(:name) { |n| "TEST_NAME#{n}"}
    # sequence(:email) { |n| "TEST#{n}@example.com"}
  end
  
  # factory :invalid_addresses do
  #   email {
  #   "user@example,com",
  #   "user_at_foo.org",
  #   "user.name@example.",
  #   "foo@bar_baz.com",
  #   "foo@bar+baz.com"
  #   }
end