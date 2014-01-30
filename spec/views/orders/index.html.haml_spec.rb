require 'spec_helper'

describe "orders/index" do
  before(:each) do
    assign(:orders, [
      stub_model(Order,
        :order_items => "Order Items"
      ),
      stub_model(Order,
        :order_items => "Order Items"
      )
    ])
  end

  it "renders a list of orders" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Order Items".to_s, :count => 2
  end
end
