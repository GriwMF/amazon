require 'spec_helper'

describe Book do
  let(:book) { FactoryGirl.create :book }
  
  it "validates presence of title" do
    expect(book).to validate_presence_of(:title)
  end
 
  it "validates presence of in_stock" do
    expect(book).to validate_presence_of(:in_stock)
  end
  
  it "validates that in_stock is integer >= 0" do
    expect(book).to validate_numericality_of(:in_stock).only_integer
    expect(book).to validate_numericality_of(:in_stock).is_greater_than_or_equal_to(0)
  end    
  
  it "has many categories through books_categories" do
    expect(book).to have_and_belong_to_many(:categories)
  end  
  
  it "has many authors through authors_books" do
    expect(book).to have_and_belong_to_many(:authors)
  end  
  
  it "has many order_items" do
    expect(book).to have_many(:order_items)
  end  

  it "has many ratings" do
    expect(book).to have_many(:ratings)
  end    
end
