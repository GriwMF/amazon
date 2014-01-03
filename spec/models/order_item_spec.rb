require 'spec_helper'

describe OrderItem do
  let(:order_item) { FactoryGirl.create :order_item }
  
  it "allows to buy book in stock" do
    expect(order_item).to be_valid
  end
  
  it "dissalow to buy book not in stock" do
    book = FactoryGirl.create :book, in_stock: 0
    expect(FactoryGirl.build :order_item, book: book).to_not be_valid
  end
  
  it "belongs to order" do
    expect(order_item).to respond_to :order
  end
  
  it "belongs to book" do
    expect(order_item).to respond_to :book
  end
end
