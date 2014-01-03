require 'spec_helper'

describe Order do
  let(:order) { FactoryGirl.create :order }
  
  it "fails without total_price" do
    expect(FactoryGirl.build :order, total_price: nil).to_not be_valid
  end
  
  it "has many books" do
    expect(order).to respond_to :books
  end
  
  it "belongs to customer" do
    expect(order).to respond_to :customer
  end

  it "billing address belongs to address" do
    expect(order).to respond_to :bill_addr
  end  
  
  it "shipping address belongs to address" do
    expect(order).to respond_to :ship_addr
  end  

  it "has one credit card" do
    expect(order).to respond_to :credit_card
  end    
  
  it "has many order items" do
    expect(order).to respond_to :order_items
  end    
end
