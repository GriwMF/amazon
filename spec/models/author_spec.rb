require 'spec_helper'

describe Author do
  it "fails without firstname" do
    expect(FactoryGirl.build :author, firstname: nil).to_not be_valid
  end
  
  it "fails without lastname" do
    expect(FactoryGirl.build :author, lastname: nil).to_not be_valid
  end
  
  it "has many books" do
    expect(FactoryGirl.build :author).to respond_to :books
  end
end
