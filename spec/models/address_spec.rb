require 'spec_helper'

describe Address do
  let(:address) { FactoryGirl.create :address }
 
  it "validates presence of country" do
    expect(address).to validate_presence_of(:country)
  end
      
  it "validates presence of address" do
    expect(address).to validate_presence_of(:address)
  end
  
  it "validates presence of city" do
    expect(address).to validate_presence_of(:city)
  end
  
  it "validates presence of phone" do
    expect(address).to validate_presence_of(:phone)
  end

end
