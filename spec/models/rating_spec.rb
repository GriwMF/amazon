require 'spec_helper'

describe Rating do
  let(:rating) { FactoryGirl.create :rating }
  
  it "allows to rate first time" do
    expect(FactoryGirl.build :rating).to be_valid
  end
  
  it "disallow to rate book twice" do
    us = FactoryGirl.create :rating
    expect(FactoryGirl.build :rating, book_id: us.book_id, customer_id: us.customer_id).to_not be_valid
  end
  
  it "rating should be in 1..5" do
    expect(rating).to ensure_inclusion_of(:rating).in_range(1..5)
  end  
  
  it "belongs to customer" do
    expect(rating).to belong_to(:customer)
  end
  
  it "belongs to book" do
    expect(rating).to belong_to(:book)
  end
end
