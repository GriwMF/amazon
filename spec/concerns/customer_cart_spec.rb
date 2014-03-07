require 'spec_helper'

describe CustomerCart do
  let (:customer) { FactoryGirl.create :customer }
  let (:test_class) { Struct.new(:current_customer, :cookies) { include CustomerCart } }
  let (:cart) { test_class.new(customer, { :cart_name => '1' } ) }
  let (:no_one_cart) { test_class.new(nil, { :cart_name => '1' } ) }

  it 'returns cart of existing customer' do
    expect(customer).to receive(:cart).and_return('cart here')
    expect(cart.current_cart).to eq('cart here')
  end

  it 'loads order with id from cookies' do
    order = mock_model(Order, empty?: false, customer: false)
    Order.stub_chain(:where, :first).and_return(order)
    expect(no_one_cart.current_cart).to eq(order)
  end

  it 'creates new order and set cookie if not exist or had customer' do
    Order.stub_chain(:where, :first).and_return(nil)
    order = no_one_cart.current_cart
    expect(order.state).to eq ('in_progress')
    expect(no_one_cart.cookies[:cart_name]).to eq(order.id)
  end
end