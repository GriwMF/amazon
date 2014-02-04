# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    customer
    credit_card
    bill_addr
    ship_addr
    factory :order_with_book_price_5_and_quantity_3 do
      ignore do
       customer nil
      end
      after :create do |order, evaluator|
        create_list :order_item, 3, {order: order, quantity: 3}
      end
    end
  end
end
