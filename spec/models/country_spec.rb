require 'spec_helper'

describe Country do
  let(:country) { FactoryGirl.create :country }
  
  it "validates presence of name" do
    expect(country).to validate_presence_of(:name)
  end
  
  it "has many addresses" do
    expect(country).to have_many(:addresses)
  end
end
