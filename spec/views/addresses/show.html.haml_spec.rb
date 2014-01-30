require 'spec_helper'

describe "addresses/show" do
  before(:each) do
    @address = assign(:address, stub_model(Address,
      :country => "Country",
      :address => "Address",
      :zipcode => "Zipcode",
      :city => "City",
      :phone => "Phone"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Country/)
    rendered.should match(/Address/)
    rendered.should match(/Zipcode/)
    rendered.should match(/City/)
    rendered.should match(/Phone/)
  end
end
