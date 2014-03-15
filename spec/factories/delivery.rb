# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :delivery do
    title Faker::Name.title
    price 5
  end
end
