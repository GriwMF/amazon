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
  
  its "state are in %w(pending approved declined)" do
    expect(rating).to ensure_inclusion_of(:state).in_array(%w(pending approved declined))
  end

  it { expect(rating).to validate_presence_of :title}
  
  context "approved scope" do
    it "includes approved rating" do
      approved_rating = FactoryGirl.create :rating, state: 'approved'
      expect(Rating.approved).to include approved_rating
    end
    
    it "excludes ratings with state not equal approved" do
      expect(Rating.approved).to_not include rating      
    end
  end
end
