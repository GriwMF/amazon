require 'spec_helper'

describe Author do
  let(:author) { FactoryGirl.create :author }
  
  it "validates presence of firstname" do
    expect(author).to validate_presence_of(:firstname)
  end
  
  it "validates presence of lastname" do
    expect(author).to validate_presence_of(:lastname)
  end
  
  it "has many books through authors_books" do
    expect(author).to have_and_belong_to_many(:books)
  end
end
