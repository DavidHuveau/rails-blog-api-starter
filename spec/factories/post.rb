FactoryGirl.define do
  factory :post do
    title Faker::Lorem.word
    detail Faker::Lorem.sentence
    published false
    user
  end
end
