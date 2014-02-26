require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe OrdersController do
  include Devise::TestHelpers

  let(:customer) { FactoryGirl.create :customer }
  # This should return the minimal set of attributes required to create a valid
  # Order. As you add validations to Order, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "ship_addr_id" => "1", "bill_addr_id" => "2", "credit_card_id" => "3" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # OrdersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  let(:ability) { Object.new.extend(CanCan::Ability) }
  
  before do
    sign_in customer
  end
  
  describe "GET index" do
    it "assigns completed orders of customer as @orders" do
      order = FactoryGirl.create :order, customer: customer, 
                                 completed_at: Time.now, state: 'in_queue'
      get :index, {}, valid_session
      assigns(:orders).should eq([order])
    end

    it 'redirect to root if havent read ability' do
      allow(@controller).to receive(:current_ability).and_return(ability)
      ability.cannot :read, Order
      get :index
      response.should redirect_to(root_url)
    end  
  end
  
  describe "GET recent" do
    it "assigns completed orders of customer in last 3 month as @orders" do
      order = FactoryGirl.create :order, customer: customer, completed_at: Time.now
      FactoryGirl.create :order, customer: customer, completed_at: Time.now - 1.year
      get :recent, {}, valid_session
      assigns(:orders).should eq([order])
    end

    it 'redirect to root if havent recent ability' do
      allow(@controller).to receive(:current_ability).and_return(ability)
      ability.cannot :recent, Order
      get :recent
      response.should redirect_to(root_url)
    end  
  end

  describe "GET show" do
    it 'redirect to root if havent read ability' do
      allow(@controller).to receive(:current_ability).and_return(ability)
      ability.cannot :read, Order
      get :show, { id: '1' }
      response.should redirect_to(root_url)
    end  

    it "assigns the requested order as @order" do
      order = FactoryGirl.create :order, customer: customer, state: "in_progress"
      get :show, {:id => order.to_param}, valid_session
      assigns(:order).should eq(order)
    end

    it "assigns customer's addresses as @addresses" do
      order = FactoryGirl.create :order, customer: customer, state: "in_progress"
      allow(@controller).to receive(:current_customer).and_return(customer)
      address = mock_model(Address)
      customer.stub_chain('addresses.decorate').and_return(address)
      get :show, {:id => order.to_param}, valid_session
      assigns(:addresses).should eq(address)
    end

    it "raises routing error if state is not in_progress" do
      order = FactoryGirl.create :order, customer: customer, state: "in_queue"
      expect {
        get :show, {:id => order.to_param}, valid_session
      }.to raise_error ActionController::RoutingError
    end
  end

  describe "PUT update" do
    it 'redirect to root if havent update ability' do
      allow(@controller).to receive(:current_ability).and_return(ability)
      ability.cannot :update, Order
      put :update, { id: '1' }
      response.should redirect_to(root_url)
    end  

    it "assigns the requested order as @order" do
      order = customer.cart
      put :update, {:id => order.to_param, :order => valid_attributes}, valid_session
      assigns(:order).should eq(order)
    end

    it "redirects to the root path" do
      order = customer.cart
      put :update, {:id => order.to_param, :order => valid_attributes}, valid_session
      response.should redirect_to(root_path)
    end


    describe "with valid params" do
      it "updates the requested order" do
        order = customer.cart

        Order.any_instance.should_receive(:update_attributes!).with({ :ship_addr_id => "1", :bill_addr_id => "2", :credit_card_id => "3"})
        Order.any_instance.should_receive(:check_out!)
        put :update, {:id => order.to_param, :order => valid_attributes}, valid_session
     
      end
    end
    
    describe "with invalid params" do
      it "assigns the error message to flash" do
        order = customer.cart
        book = FactoryGirl.create :book, in_stock: 50
        order.add_item(book, quantity: 40)
        book.in_stock = 10
        book.save
        patch :update, {:id => order.to_param, :order => valid_attributes}, valid_session
        expect(flash[:danger]).to include("Validation failed: In stock must be greater than or equal to 0")
      end
    end
  end

  describe "POST add_item" do
    before do
      request.env["HTTP_REFERER"] = books_path
    end

    it 'redirect to root if havent add_item ability' do
      allow(@controller).to receive(:current_ability).and_return(ability)
      ability.cannot :add_item, Order
      post :add_item, { id: '1' }
      response.should redirect_to(root_url)
    end  
    
    describe "with valid params" do
      let(:book) { mock_model(Book, id: 1, title: 'post name', description: 'description text', save: true, errors: []) }
      
      before do
        allow_any_instance_of(Order).to receive(:add_item).and_return(book)
        allow_any_instance_of(Order).to receive(:refresh_prices)
        allow(Book).to receive(:find).and_return(book)
      end

      it "redirects back" do
        book = FactoryGirl.create :book
        post :add_item, {:id => book.to_param}, valid_session
        expect(response).to redirect_to(books_path)
      end
      
      it "calls add_item method of model with book id and quantity" do
        expect_any_instance_of(Order).to receive(:add_item).with(book, {:quantity=> 3})
        post :add_item, {:id => book.to_param, quantity: 3}, valid_session
      end
      
      it "adds successefull flash message" do
        post :add_item, {:id => book.to_param}, valid_session
        expect(flash[:info]).to eq('Book was successefully added')
      end
      
      it "calls :refresh_prices on order" do
        expect_any_instance_of(Order).to receive(:refresh_prices)
        post :add_item, {:id => book.to_param}, valid_session
      end

    end
    
    describe "with invalid params" do
      it "adds error message" do
        err = ["error"]
        allow(err).to receive(:full_messages).and_return(["error"])
        book = mock_model(Book, id: 1, title: 'post name', description: 'description text', save: true, errors: err)
        allow_any_instance_of(Order).to receive(:add_item).and_return(book)
        allow_any_instance_of(Order).to receive(:refresh_prices)
        allow(Book).to receive(:find).and_return(book)
        
        post :add_item, {:id => book.to_param}, valid_session
        expect(flash[:info]).to_not eq(I18n.t 'suc_book_added')
        expect(flash[:danger]).to eq(['error'])
      end
    end
  end
  
  describe "DELETE remove_item" do
    let(:item_id) { 1 }

    before do
      request.env["HTTP_REFERER"] = books_path
    end
    
    it 'redirect to root if havent remove_item ability' do
      allow(@controller).to receive(:current_ability).and_return(ability)
      ability.cannot :remove_item, Order
      delete :remove_item, { id: '1' }
      response.should redirect_to(root_url)
    end  
    
    it "redirects back" do
      allow_any_instance_of(Order).to receive(:remove_item)
      delete :remove_item, {:id => item_id}, valid_session
      expect(response).to redirect_to(books_path)
    end
    
    it "remove item from cart" do
        expect_any_instance_of(Order).to receive(:remove_item).with(item_id.to_s)
        delete :remove_item, {:id => item_id}, valid_session
    end
  end
end
