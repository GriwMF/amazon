# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :book do
    title "War and Peace"
    price 19.99
    in_stock 5
    author
    category
  end
end
