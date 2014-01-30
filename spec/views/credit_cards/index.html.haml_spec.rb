require 'spec_helper'

describe "credit_cards/index" do
  before(:each) do
    assign(:credit_cards, [
      stub_model(CreditCard,
        :firstname => "Firstname",
        :lastname => "Lastname",
        :number => "Number",
        :cvv => "Cvv",
        :expiration_month => "Expiration Month",
        :expiration_year => "Expiration Year"
      ),
      stub_model(CreditCard,
        :firstname => "Firstname",
        :lastname => "Lastname",
        :number => "Number",
        :cvv => "Cvv",
        :expiration_month => "Expiration Month",
        :expiration_year => "Expiration Year"
      )
    ])
  end

  it "renders a list of credit_cards" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Firstname".to_s, :count => 2
    assert_select "tr>td", :text => "Lastname".to_s, :count => 2
    assert_select "tr>td", :text => "Number".to_s, :count => 2
    assert_select "tr>td", :text => "Cvv".to_s, :count => 2
    assert_select "tr>td", :text => "Expiration Month".to_s, :count => 2
    assert_select "tr>td", :text => "Expiration Year".to_s, :count => 2
  end
end
