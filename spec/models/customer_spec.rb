require 'spec_helper'

describe Customer do
  let(:customer) { FactoryGirl.create :customer }
  
  it "has unique email" do
    expect(customer).to validate_uniqueness_of(:email)
  end

  it "has many credit cards" do
    expect(customer).to have_many(:credit_cards)
  end
  
  it "has many addresses" do
    expect(customer).to have_many(:addresses)
  end
  
  it "has many credit orders" do
    expect(customer).to have_many(:orders)
  end
  
  it "has many ratings" do
    expect(customer).to have_many(:ratings)
  end

  it "has and belongs to many wished_books" do
    expect(customer).to have_and_belong_to_many(:wished_books)
  end

  it { expect(customer).to validate_presence_of(:firstname) }

  it { expect(customer).to validate_presence_of(:lastname) }
  
  context ".cart" do
    it "creates or returns cart" do
      order = customer.cart
      expect(customer.orders.where(state: "in_progress")).to match_array([order])
    end
  end
end
