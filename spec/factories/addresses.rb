# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :address, aliases: [:ship_addr, :bill_addr] do
    address "Kirova 666"
    zipcode "49000"
    city "Dnepropetrovsk"
    phone "+31345765454676"
    country
  end
end
