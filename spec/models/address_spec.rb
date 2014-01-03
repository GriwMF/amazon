require 'spec_helper'

describe Address do
  let(:address) { FactoryGirl.create :address }
    
  it "fails without address" do
    expect(FactoryGirl.build :address, address: nil).to_not be_valid
  end
  
  it "fails without city" do
    expect(FactoryGirl.build :address, city: nil).to_not be_valid
  end
  
  it "fails without phone" do
    expect(FactoryGirl.build :address, phone: nil).to_not be_valid
  end

  it "has many bill_orders" do
    expect(address).to respond_to :bill_orders
  end  
 
  it "has many ship_orders" do
    expect(address).to respond_to :ship_orders
  end   
end
