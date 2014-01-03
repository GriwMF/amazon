# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :credit_card do
    number "12345678901234"
    cvv "123"
    expiration_month 12
    expiration_year 2016
    firstname "John"
    lastname "Galt"
    customer
    order
  end
end
