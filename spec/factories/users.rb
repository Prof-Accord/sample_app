FactoryBot.define do
  sequence :name do |n|
    "User #{n}"
  end
  sequence :email do |n|
    "example#{n}@email.com"
  end
  
  factory :michael, :class => 'User' do
    name { "Michael Example" }
    email { "michael@example.com" }
    password { "password" }
    password_confirmation { "password" }
    admin { true }
  end
  
  factory :archer, :class => 'User' do
    name { "Sterling Archer" }
    email { "duchess@example.gov" }
    password { "password" }
    password_confirmation { "password" }
    admin { false }
  end
    
  #   trait :lana do
  #     name { "Lana Kane" }
  #     email { "hands@example.gov" }
  #   end
    
  #   trait :malory do
  #     name { "Malory Archer" }
  #     email { "boss@example.gov" }
  #   end
  # end
  
  factory :other_users, :class => 'User' do
    name
    email
    password { "password" }
    password_confirmation {"password" }
  end
end