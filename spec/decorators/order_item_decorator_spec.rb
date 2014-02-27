require 'spec_helper'

describe OrderItemDecorator do
  let(:decorator) { OrderItemDecorator.new(mock_model(OrderItem)) }
  
  it 'decorates associated book' do
    expect(decorator).to respond_to(:book)
  end

end