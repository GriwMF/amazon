require 'spec_helper'

describe Book do
  let(:book) { FactoryGirl.create :book }
  
  it "fails without title" do
    expect(FactoryGirl.build :book, title: nil).to_not be_valid
  end
 
  it "fails without in_stock" do
    expect(FactoryGirl.build :book, in_stock: nil).to_not be_valid
  end
  
  it "fails if in_stock < 0" do
    expect(FactoryGirl.build :book, in_stock: -1).to_not be_valid
  end    
  
  it "belongs to category" do
    expect(book).to respond_to :category
  end  
  
  it "belongs to author" do
    expect(book).to respond_to :author
  end  
  
  it "has many order_items" do
    expect(book).to respond_to :order_items
  end  

  it "has many ratings" do
    expect(book).to respond_to :ratings
  end    
end
