require 'spec_helper'

describe "credit_cards/show" do
  before(:each) do
    @credit_card = assign(:credit_card, stub_model(CreditCard,
      :firstname => "Firstname",
      :lastname => "Lastname",
      :number => "Number",
      :cvv => "Cvv",
      :expiration_month => "Expiration Month",
      :expiration_year => "Expiration Year"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Firstname/)
    rendered.should match(/Lastname/)
    rendered.should match(/Number/)
    rendered.should match(/Cvv/)
    rendered.should match(/Expiration Month/)
    rendered.should match(/Expiration Year/)
  end
end
