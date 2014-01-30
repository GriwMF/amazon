require 'spec_helper'

describe "addresses/edit" do
  before(:each) do
    @address = assign(:address, stub_model(Address,
      :country => "MyString",
      :address => "MyString",
      :zipcode => "MyString",
      :city => "MyString",
      :phone => "MyString"
    ))
  end

  it "renders the edit address form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", address_path(@address), "post" do
      assert_select "input#address_country[name=?]", "address[country]"
      assert_select "input#address_address[name=?]", "address[address]"
      assert_select "input#address_zipcode[name=?]", "address[zipcode]"
      assert_select "input#address_city[name=?]", "address[city]"
      assert_select "input#address_phone[name=?]", "address[phone]"
    end
  end
end
