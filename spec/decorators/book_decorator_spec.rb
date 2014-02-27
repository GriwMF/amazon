require 'spec_helper'

describe BookDecorator do
  let(:decorator) { BookDecorator.new(mock_model(Book, full_description: '__John__')) }
  
  context '#full_description' do
    it 'returns html of full_description, rendered with markdown' do
      expect(decorator.full_description).to eq("<p><strong>John</strong></p>\n")
    end
  end
  
  it 'decorates associated authors' do
    expect(decorator).to respond_to(:authors)
  end
end