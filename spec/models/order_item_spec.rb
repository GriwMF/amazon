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
    expect(order_item).to belong_to(:order)
  end
  
  it "belongs to book" do
    expect(order_item).to belong_to(:book)
  end
  
  context "#title" do
    it "make title for OrderItem in format: book_title + quantity" do
      expect(order_item.title).to eq("#{order_item.book.title}, Quantity: #{order_item.quantity.to_s}")
    end
  end
end
