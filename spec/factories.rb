FactoryGirl.define do
  factory :post do
    title Faker::Lorem.word
    detail Faker::Lorem.sentence
  end

  factory :user do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    email Faker::Internet.email
    password '12345678'
    password_confirmation '12345678'
  end
end
