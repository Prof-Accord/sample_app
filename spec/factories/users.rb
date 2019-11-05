FactoryBot.define do
  factory :user do
    name { "hoge" }
    email { "foo@bar.com" }
    password { "foobar" }
    password_confirmation { "foobar" }
    # sequence(:name) { |n| "TEST_NAME#{n}"}
    # sequence(:email) { |n| "TEST#{n}@example.com"}
  end
  
  factory :invalid_user do
    name  { "" }
    email { "user@invalid" }
    password { "foo" }
    password_confirmation { "bar" }
  end
end