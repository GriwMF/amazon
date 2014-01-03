require 'spec_helper'

describe Category do
  it "fails without title" do
    expect(FactoryGirl.build :category, title: nil).to_not be_valid
  end
  
  it "has many books" do
    expect(FactoryGirl.build :category).to respond_to :books
  end
end
