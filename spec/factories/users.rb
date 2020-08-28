FactoryGirl.define do
  factory :user do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    sequence(:email){|n| "user#{n}@factory.com" }
    password '12345678'
    password_confirmation '12345678'
    sequence(:authentication_token){|n| "authentication_token#{n}" }
  end
end
