require 'spec_helper'

describe Country do
  it "fails without name" do
    expect(FactoryGirl.build :country, name: nil).to_not be_valid
  end
  
  it "has many addresses" do
    expect(FactoryGirl.build :country).to respond_to :addresses
  end
end
