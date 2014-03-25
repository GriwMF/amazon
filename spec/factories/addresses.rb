# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :address, aliases: [:ship_addr, :bill_addr] do
    country Faker::Address.country
    address Faker::Address.street_address(true)
    zipcode Faker::Address.zip_code
    city Faker::Address.city
    phone Faker::PhoneNumber.phone_number
  end
end
