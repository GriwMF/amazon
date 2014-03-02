require 'spec_helper'

describe CustomersController do
  include Devise::TestHelpers
  let(:customer) { FactoryGirl.create :customer }

  before do
    sign_in customer
  end

  describe "GET show" do
    it "assigns customer's wished books as @wished_books" do
      book = mock_model(Book)
      allow(@controller).to receive(:current_customer).and_return(customer)
      allow(customer).to receive(:wished_books).and_return(book)
      allow(book).to receive(:decorate).and_return(book)
      
      get :show
      assigns(:wished_books).should eq(book)
    end

    it 'redirect to root if havent read ability' do
      ability = Object.new.extend(CanCan::Ability)
      allow(@controller).to receive(:current_ability).and_return(ability)
      ability.cannot :read, Customer
      get :show
      response.should redirect_to(root_url)
    end
    
    it 'decorates @wished_books' do
      get :show
      expect(assigns(:wished_books)).to be_decorated
    end
  end
end