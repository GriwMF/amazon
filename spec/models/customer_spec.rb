require 'spec_helper'

describe Customer do
  let(:customer) { FactoryGirl.create :customer }
  
  it "has unique email" do
    expect(customer).to validate_uniqueness_of(:email)
  end

  it "has many credit cards" do
    expect(customer).to have_many(:credit_cards)
  end
  
  it "has many credit orders" do
    expect(customer).to have_many(:orders)
  end
  
  it "has many ratings" do
    expect(customer).to have_many(:ratings)
  end
end
