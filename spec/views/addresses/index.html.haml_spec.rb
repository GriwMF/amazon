require 'spec_helper'

describe "addresses/index" do
  before(:each) do
    assign(:addresses, [
      stub_model(Address,
        :country => "Country",
        :address => "Address",
        :zipcode => "Zipcode",
        :city => "City",
        :phone => "Phone"
      ),
      stub_model(Address,
        :country => "Country",
        :address => "Address",
        :zipcode => "Zipcode",
        :city => "City",
        :phone => "Phone"
      )
    ])
  end

  it "renders a list of addresses" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Country".to_s, :count => 2
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    assert_select "tr>td", :text => "Zipcode".to_s, :count => 2
    assert_select "tr>td", :text => "City".to_s, :count => 2
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
  end
end
