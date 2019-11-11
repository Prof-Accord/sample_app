FactoryBot.define do
  factory :user do
    name { "hoge" }
    email { "foo@bar.com" }
    password { "password" }
    password_confirmation { "password" }
    # sequence(:name) { |n| "TEST_NAME#{n}"}
    # sequence(:email) { |n| "TEST#{n}@example.com"}
  end
end