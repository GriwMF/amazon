require 'spec_helper'

describe AuthorDecorator do
  context '#full_name' do
    it 'returns firstname + lastname' do
      author = mock_model(Author, firstname: 'John', lastname: 'Galt')
      decorator = AuthorDecorator.new(author)
      expect(decorator.full_name).to eq('John Galt')
    end
  end
end