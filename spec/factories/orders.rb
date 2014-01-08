# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    total_price 666
    state "waiting for confirmation"
    customer
    bill_addr
    ship_addr
    factory :order_with_items do
      ignore do
        customer nil
      end
      after :create do |order, _|
        create_list :order_item, 3, order: order
      end
    end
  end
end
