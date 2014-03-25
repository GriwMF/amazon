require 'spec_helper'

describe CreditCard do
  let(:credit_card) { FactoryGirl.create :credit_card }

  it "validates presence of cvv" do
    expect(credit_card).to validate_presence_of(:cvv)
  end
  
  it "validates presence of number" do
    expect(credit_card).to validate_presence_of(:number)
  end
  
  it "validates presence of expiration month" do
    expect(credit_card).to validate_presence_of(:expiration_month)
  end

  it "validates presence of expiration year" do
    expect(credit_card).to validate_presence_of(:expiration_year)
  end
    
  it "card number has 16 digits" do
    expect(credit_card).to allow_value('1234567890123456').for(:number)
    expect(credit_card).to_not allow_value('123456789012345').for(:number)
    expect(credit_card).to_not allow_value('12345678901234567').for(:number)
  end
  
  it "validates expiration month in 1..12" do
    expect(credit_card).to ensure_inclusion_of(:expiration_month).in_range(1..12)
  end
  
  it "validates expiration year in current and current + 20" do
    year = Time.now.year
    expect(credit_card).to ensure_inclusion_of(:expiration_year).in_range(year..year+20)
  end

end
