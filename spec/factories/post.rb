FactoryGirl.define do
  factory :post do
    title Faker::Lorem.word
    detail Faker::Lorem.sentence
  end
end
