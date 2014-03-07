# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :book do
    title  Faker::Name.title
    description Faker::Lorem.sentence
    full_description Faker::Lorem.sentence
    price 5
    in_stock 3
  end
end
