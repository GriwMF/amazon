require 'spec_helper'

describe CustomersController do
  include Devise::TestHelpers
  let(:customer) { FactoryGirl.create :customer }

  let(:valid_attributes) {  { "country" => "MyString", "address" => "address", "zipcode" => "23434",
                             "city" => "Dnepr", "phone" => "454334554" } }
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

  describe "POST ship_create" do
    it 'redirect to root if havent ship_create ability' do
      ability = Object.new.extend(CanCan::Ability)
      allow(@controller).to receive(:current_ability).and_return(ability)
      ability.cannot :ship_create, Customer
      post :ship_create
      response.should redirect_to(root_url)
    end

    context "valid attributes" do
      it 'creates new customers ship address' do
        allow(@controller).to receive(:current_customer).and_return(customer)
        post :ship_create, :address => valid_attributes
        expect(customer.ship_addr.phone).to eq "454334554"
      end

      it 'redirect to customer_path' do
        post :ship_create, :address => valid_attributes
        response.should redirect_to(customer_path)
      end
    end

    context "invalid attributes" do
      before do
        post :ship_create, :address => valid_attributes.merge(:phone => "")
      end

      it 'renders show' do
        response.should render_template(:show)
      end

      it 'adds flash messages' do
        expect(flash.now[:danger]).to include("Phone can't be blank")
      end
    end
  end

  describe "PATCH ship_update" do

    it 'redirect to root if havent ship_update ability' do
      ability = Object.new.extend(CanCan::Ability)
      allow(@controller).to receive(:current_ability).and_return(ability)
      ability.cannot :ship_update, Customer
      patch :ship_update
      response.should redirect_to(root_url)
    end

    it "updates ship_addr when valid attributes" do
      allow(@controller).to receive(:current_customer).and_return(customer)
      patch :ship_update, :address => valid_attributes
      expect(customer.ship_addr.phone).to eq "454334554"
    end

    it "adds flash messages when invalid attributes" do
      patch :ship_update, :address => valid_attributes.merge(:phone => "")
      expect(flash[:danger]).to include("Phone can't be blank")
    end
  end

  describe "POST bill_create" do
    it 'redirect to root if havent ship_create ability' do
      ability = Object.new.extend(CanCan::Ability)
      allow(@controller).to receive(:current_ability).and_return(ability)
      ability.cannot :bill_create, Customer
      post :bill_create
      response.should redirect_to(root_url)
    end

    context "valid attributes" do
      it 'creates new customers ship address' do
        allow(@controller).to receive(:current_customer).and_return(customer)
        post :bill_create, :address => valid_attributes
        expect(customer.bill_addr.phone).to eq "454334554"
      end

      it 'redirect to customer_path' do
        post :bill_create, :address => valid_attributes
        response.should redirect_to(customer_path)
      end
    end

    context "invalid attributes" do
      before do
        post :bill_create, :address => valid_attributes.merge(:phone => "")
      end

      it 'renders show' do
        response.should render_template(:show)
      end

      it 'adds flash messages' do
        expect(flash.now[:danger]).to include("Phone can't be blank")
      end
    end
  end

  describe "PATCH bill_update" do
    it 'redirect to root if havent ship_update ability' do
      ability = Object.new.extend(CanCan::Ability)
      allow(@controller).to receive(:current_ability).and_return(ability)
      ability.cannot :bill_update, Customer
      patch :bill_update
      response.should redirect_to(root_url)
    end

    it "updates bill_addr when valid attributes" do
      allow(@controller).to receive(:current_customer).and_return(customer)
      patch :bill_update, :address => valid_attributes
      expect(customer.bill_addr.phone).to eq "454334554"
    end

    it "adds flash messages when invalid attributes" do
      patch :bill_update, :address => valid_attributes.merge(:phone => "")
      expect(flash[:danger]).to include("Phone can't be blank")
    end
  end
end