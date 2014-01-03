# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    total_price 666
    state "waiting for confirmation"
    customer
    bill_addr
    ship_addr
  end
end
