FactoryBot.define do
  
  sequence :name do |n|
    "User #{n}"
  end
  sequence :email do |n|
    "example#{n}@email.com"
  end
  
  factory :michael, class: User do
    name { "Michael Example" }
    email { "michael@example.com" }
    password { "password" }
    password_confirmation { "password" }
    admin { true }
    activated { true }
    activated_at { Time.zone.now }
  end
  
  factory :archer, class: User do
    name { "Sterling Archer" }
    email { "duchess@example.gov" }
    password { "password" }
    password_confirmation { "password" }
    admin { false }
    activated { true }
    activated_at { Time.zone.now }
  end
    
  factory :lana, class: User do
    name { "Lana Kane" }
    email { "hands@example.gov" }
    password { "password" }
    password_confirmation { "password" }
    activated { false }
    activated_at { Time.zone.now }
  end
    
  factory :malory, class: User do
    name { "Malory Archer" }
    email { "boss@example.gov" }
    activated { true }
    activated_at { Time.zone.now }
  end
  
  factory :other_users, class: User do
    name
    email
    password { "password" }
    password_confirmation {"password" }
    activated { true }
    activated_at { Time.zone.now }
  end
end