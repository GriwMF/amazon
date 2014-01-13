# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :credit_card do
    number "1234567890123456"
    cvv "123"
    expiration_month 12
    expiration_year 2016
    firstname "John"
    lastname "Galt"
    customer
  end
end
