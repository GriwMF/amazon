# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :email do |n|
    "email#{n}@factory.com"
  end
  
  factory :customer do
    email { FactoryGirl.generate(:email) } 
    password "123123123"
    firstname Faker::Name.first_name
    lastname Faker::Name.last_name
    bill_addr
    ship_addr
    
    factory :admin_customer do
      admin true
    end
  end
end
