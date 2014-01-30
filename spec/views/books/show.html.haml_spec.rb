require 'spec_helper'

describe "books/show" do
  before(:each) do
    @book = assign(:book, stub_model(Book,
      :title => "Title",
      :descirption => "Descirption",
      :price => "Price",
      :in_stock => "In Stock"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    rendered.should match(/Descirption/)
    rendered.should match(/Price/)
    rendered.should match(/In Stock/)
  end
end
