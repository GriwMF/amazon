require 'spec_helper'

describe "books/index" do
  before(:each) do
    assign(:books, [
      stub_model(Book,
        :title => "Title",
        :descirption => "Descirption",
        :price => "Price",
        :in_stock => "In Stock"
      ),
      stub_model(Book,
        :title => "Title",
        :descirption => "Descirption",
        :price => "Price",
        :in_stock => "In Stock"
      )
    ])
  end

  it "renders a list of books" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Descirption".to_s, :count => 2
    assert_select "tr>td", :text => "Price".to_s, :count => 2
    assert_select "tr>td", :text => "In Stock".to_s, :count => 2
  end
end
