require 'spec_helper'

describe AddressDecorator do
  context '#full' do
    it 'returns country, city, and address fields, splitted bu space' do
      address = mock_model(Address, country: 'Ukraine', city: 'Dnipro', address: '666')
      decorator = AddressDecorator.new(address)
      expect(decorator.full).to eq('Ukraine Dnipro 666')
    end
  end
end