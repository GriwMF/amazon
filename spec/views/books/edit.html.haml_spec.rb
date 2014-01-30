require 'spec_helper'

describe "books/edit" do
  before(:each) do
    @book = assign(:book, stub_model(Book,
      :title => "MyString",
      :descirption => "MyString",
      :price => "MyString",
      :in_stock => "MyString"
    ))
  end

  it "renders the edit book form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", book_path(@book), "post" do
      assert_select "input#book_title[name=?]", "book[title]"
      assert_select "input#book_descirption[name=?]", "book[descirption]"
      assert_select "input#book_price[name=?]", "book[price]"
      assert_select "input#book_in_stock[name=?]", "book[in_stock]"
    end
  end
end
