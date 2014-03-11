# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rating do
    rating 3
    title Faker::Lorem.sentence
    text Faker::Lorem.sentence
    book
    customer
  end
end
