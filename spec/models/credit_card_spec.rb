require 'spec_helper'

describe CreditCard do
  let(:credit_card) { FactoryGirl.create :credit_card }
  
  it "fails without firstname" do
    expect(FactoryGirl.build :credit_card, firstname: nil).to_not be_valid
  end
  
  it "fails without lastname" do
    expect(FactoryGirl.build :credit_card, lastname: nil).to_not be_valid
  end
  
  it "fails without cvv" do
    expect(FactoryGirl.build :credit_card, cvv: nil).to_not be_valid
  end
  
  it "fails without card number" do
    expect(FactoryGirl.build :credit_card, number: nil).to_not be_valid
  end
  
  it "card number has 14 digits" do
    expect(FactoryGirl.build :credit_card, number: "345").to_not be_valid
  end
  
  it "expiration_month fails if not in 1..12" do
    expect(FactoryGirl.build :credit_card, expiration_month: 13).to_not be_valid
  end
 
  it "fails without expiration_month" do
    expect(FactoryGirl.build :credit_card, expiration_month: nil).to_not be_valid
  end 
  
  it "fails without expiration_year" do
    expect(FactoryGirl.build :credit_card, expiration_year: nil).to_not be_valid
  end

  it "belongs to customer" do
    expect(credit_card).to respond_to :customer
  end

  it "belongs to order" do
    expect(credit_card).to respond_to :order
  end  
end
