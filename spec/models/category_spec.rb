require 'spec_helper'

describe Category do
  let(:category) { FactoryGirl.create :category }
  
  it "validates presence of title" do
    expect(category).to validate_presence_of(:title)
  end
  
  it "has many books through books_categories" do
    expect(category).to have_and_belong_to_many(:books)
  end
end
