# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order_item do
    price 19.99
    quantity 1
    book
    order
  end
end
