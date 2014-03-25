require 'spec_helper'

describe OrderDecorator do
  let(:decorator) { OrderDecorator.new(mock_model(Order)) }
  
  it 'decorates associated order_items' do
    expect(decorator).to respond_to(:order_items)
  end
  
  it 'decorates associated ship_addr' do
    expect(decorator).to respond_to(:ship_addr)
  end
  
  it 'decorates associated bill_addr' do
    expect(decorator).to respond_to(:bill_addr)
  end
end