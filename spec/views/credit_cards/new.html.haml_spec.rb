require 'spec_helper'

describe "credit_cards/new" do
  before(:each) do
    assign(:credit_card, stub_model(CreditCard,
      :firstname => "MyString",
      :lastname => "MyString",
      :number => "MyString",
      :cvv => "MyString",
      :expiration_month => "MyString",
      :expiration_year => "MyString"
    ).as_new_record)
  end

  it "renders new credit_card form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", credit_cards_path, "post" do
      assert_select "input#credit_card_firstname[name=?]", "credit_card[firstname]"
      assert_select "input#credit_card_lastname[name=?]", "credit_card[lastname]"
      assert_select "input#credit_card_number[name=?]", "credit_card[number]"
      assert_select "input#credit_card_cvv[name=?]", "credit_card[cvv]"
      assert_select "input#credit_card_expiration_month[name=?]", "credit_card[expiration_month]"
      assert_select "input#credit_card_expiration_year[name=?]", "credit_card[expiration_year]"
    end
  end
end
