require 'spec_helper'

describe Customer do
  let(:customer) { FactoryGirl.create :customer }
  
  it "fails without firstname" do
    expect(FactoryGirl.build :customer, firstname: nil).to_not be_valid
  end
  
  it "fails without lastname" do
    expect(FactoryGirl.build :customer, lastname: nil).to_not be_valid
  end
  
  it "has unique email" do
    expect(FactoryGirl.create :customer, email: "john@gmail.com").to be_valid
    expect(FactoryGirl.build :customer, email: "john@gmail.com").to_not be_valid
  end

  it "has many credit cards" do
    expect(customer).to respond_to :credit_cards
  end
  
  it "has many credit orders" do
    expect(customer).to respond_to :orders
  end
  
  it "has many ratings" do
    expect(customer).to respond_to :ratings
  end
end
