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
    
    it "decorates @orders" do
      get :index, {}, valid_session
      expect(assigns(:orders)).to be_decorated
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
    
    it "decorates @orders" do
      get :recent
      expect(assigns(:orders)).to be_decorated
    end
  end

  describe "GET show" do
    it 'redirect to root if havent read ability' do
      allow(@controller).to receive(:current_ability).and_return(ability)
      ability.cannot :read, Order
      get :show, {id: 1}
      response.should redirect_to(root_url)
    end

    it "assigns the requested order as @order" do
      get :show, {id: customer.cart.to_param}
      assigns(:order).should eq(customer.cart)
    end
  end

  describe "GET cart" do
    it 'redirect to root if havent read ability' do
      allow(@controller).to receive(:current_ability).and_return(ability)
      ability.cannot :cart, Order
      get :cart
      response.should redirect_to(root_url)
    end

    it "assigns the requested order as @order" do
      get :cart
      assigns(:order).should eq(customer.cart)
    end

    it "decorates @order" do
      get :cart
      expect(assigns(:order)).to be_decorated
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
      put :update, {:order => valid_attributes}, valid_session
      assigns(:order).should eq(order)
    end

    it "redirects to the cart" do
      order = customer.cart
      put :update, {:order => valid_attributes}, valid_session
      response.should redirect_to(cart_orders_path)
    end

    it "calls prepare_check_out if commit = Checkout" do
      order = customer.cart
      expect(@controller).to receive(:prepare_check_out).and_call_original
      put :update, {:order => valid_attributes, :commit => 'Checkout'}, valid_session
    end

    describe "with valid params" do
      it "updates the requested order" do
        order = customer.cart

        Order.any_instance.should_receive(:update_attributes).and_return(true)
        Order.any_instance.should_receive(:refresh_prices)
        put :update, {:order => valid_attributes}, valid_session
      end

      context 'coupon' do
        it "adds message if no coupons with requested code" do
          put :update, {:order => valid_attributes, :coupon_code => '1234tt'}, valid_session
          expect(flash[:danger]).to include("No coupon with this code found")
        end

        it "assigns coupon to order" do
          coupon = FactoryGirl.create :coupon, code: 'TTDS'
          put :update, {:order => valid_attributes, :coupon_code => 'TTDS'}, valid_session
          expect(customer.cart.coupon).to eq coupon
        end
      end
    end
    
    describe "with invalid params" do
      it "assigns the error message to flash" do
        order = customer.cart
        book = FactoryGirl.create :book, in_stock: 10
        patch :update, {:order => {:order_items_attributes => { id: order.add_item(book).to_param, quantity: 40} }}
        expect(flash[:danger]).to include("Order items book are not in stock")
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

      it "redirects to cart" do
        book = FactoryGirl.create :book
        post :add_item, {:id => book.to_param}, valid_session
        expect(response).to redirect_to(cart_orders_path)
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

    it 'calls refresh_prices' do
      expect_any_instance_of(Order).to receive(:refresh_prices)
      expect_any_instance_of(Order).to receive(:remove_item).with('1')
      delete :remove_item, {:id => item_id}, valid_session
    end
  end

  describe "GET check_out" do
    it 'redirect to root if havent check_out ability' do
      allow(@controller).to receive(:current_ability).and_return(ability)
      ability.cannot :check_out, Order
      get :check_out, {:step => 2}
      response.should redirect_to(root_url)
    end

    it "renders orders/check_out/check_out_(step) template" do
      session['state'] = 2
      get :check_out, {:step => 2}
      expect(response).to render_template('orders/check_out/check_out_2')
    end

    it 'calls refresh_prices if step = 4' do
      session['state'] = 4
      expect_any_instance_of(Order).to receive(:refresh_prices)
      get :check_out, {:step => 4}
    end

    it 'calls build_credit_card if step = 3' do
      session['state'] = 3
      expect_any_instance_of(Order).to receive(:build_credit_card)
      get :check_out, {:step => 3}
    end
  end

  describe "PATCH addresses" do
    before do
      allow(@controller).to receive(:update_customer_addresses)
      session['state'] = 5
    end

    context 'invalid params' do
      it 'assigns error message' do
        patch :addresses, order: {ship_addr_attributes: {address: '000'}}
        expect(flash.now[:danger]).to be_any
      end

      it "renders  orders/check_out/check_out_1 template" do
        patch :addresses, order: {ship_addr_attributes: {address: '000'}}
        expect(response).to render_template('orders/check_out/check_out_1')
      end
    end

    it 'redirect to root if havent addresses ability' do
      allow(@controller).to receive(:current_ability).and_return(ability)
      ability.cannot :addresses, Order
      patch :addresses
      response.should redirect_to(root_url)
    end

    it 'calls update_addresses' do
      expect(@controller).to receive(:update_addresses).and_return(true)
      patch :addresses
    end

    it 'calls update_customer_addresses' do
      allow(@controller).to receive(:update_addresses).and_return(true)
      expect(@controller).to receive(:update_customer_addresses)

      patch :addresses
    end

    it 'calls set_state_and_redirect' do
      allow(@controller).to receive(:update_addresses).and_return(true)
      expect(@controller).to receive(:set_state_and_redirect).and_call_original

      patch :addresses
    end
  end

  describe "PATCH delivery" do
    let(:delivery) { mock_model(Delivery) }

    before do
      session['state'] = 5
      allow(Delivery).to receive(:find).and_return(delivery)
    end

    context 'no params' do
      it 'assigns error message' do
        patch :delivery
        expect(flash.now[:danger]).to include('Please, select one delivery method')
      end

      it "redirect to delivery select" do
        patch :delivery
        expect(response).to redirect_to '/orders/check_out/2'
      end
    end

    it 'redirect to root if havent addresses ability' do
      allow(@controller).to receive(:current_ability).and_return(ability)
      ability.cannot :delivery, Order
      patch :delivery
      response.should redirect_to(root_url)
    end

    it 'assigns delivery to @order.delivery' do
      patch :delivery, delivery: 1
      expect(assigns(:order).delivery).to eq delivery
    end

    it 'calls set_state_and_redirect' do
      expect(@controller).to receive(:set_state_and_redirect).and_call_original

      patch :delivery, delivery: 1
    end
  end

  describe "PATCH credit_card" do
    before do
      session['state'] = 5
    end

    it 'redirect to root if havent credit_card ability' do
      allow(@controller).to receive(:current_ability).and_return(ability)
      ability.cannot :credit_card, Order
      patch :credit_card
      response.should redirect_to(root_url)
    end

    context 'invalid params' do
      it 'assigns error message' do
        patch :credit_card, order: {credit_card_attributes: {number: '000'}}
        expect(flash.now[:danger]).to be_any
      end

      it "redirect to credit card select" do
        patch :credit_card, order: {credit_card_attributes: {number: '000'}}
        expect(response).to redirect_to '/orders/check_out/3'
      end
    end

    it 'calls set_state_and_redirect' do
      expect(@controller).to receive(:set_state_and_redirect).and_call_original

      patch :credit_card, order: {credit_card_params: {}}
    end

    it "updates order's attributes" do
      expect_any_instance_of(Order).to receive(:update_attributes)

      patch :credit_card, order: {credit_card_params: {}}
    end
  end

  describe "GET complete" do

    it 'redirect to root if havent credit_card ability' do
      allow(@controller).to receive(:current_ability).and_return(ability)
      ability.cannot :complete, Order
      get :complete
      response.should redirect_to(root_url)
    end

    context 'invalid params' do
      before do
        session['state'] = 5
      end

      it 'assigns error message' do
        get :complete
        expect(flash.now[:danger]).to eq("Please, process checkout step by step!")
      end

      it "redirect to cart" do
        get :complete
        expect(response).to redirect_to cart_orders_path
      end
    end

    it 'calls check_out! on order' do
      session['state'] = 4
      expect_any_instance_of(Order).to receive(:check_out!)

      get :complete
    end

    it 'deletes session[state]' do
      session['state'] = 4
      get :complete
      expect(session['state']).to be_nil
    end

    it "renders complete template" do
      session['state'] = 4
      get :complete
      expect(response).to render_template('complete')
    end
  end

  describe "DELETE destroy" do
    it 'redirect to root if havent destroy ability' do
      allow(@controller).to receive(:current_ability).and_return(ability)
      ability.cannot :destroy, Order
      delete :destroy
      response.should redirect_to(root_url)
    end

    it 'assigns flash message' do
      delete :destroy
      expect(flash[:success]).to eq('Cart has been cleaned')
    end

    it "redirect to books" do
      delete :destroy
      expect(response).to redirect_to books_path
    end

    it 'calls refresh_prices on order' do
      expect_any_instance_of(Order).to receive(:refresh_prices)
      delete :destroy
    end

    it 'clears order_items' do
      item = mock_model(OrderItem)
      expect(item).to receive(:delete_all)
      allow_any_instance_of(Order).to receive(:order_items).and_return(item)
      allow_any_instance_of(Order).to receive(:refresh_prices)
      delete :destroy
    end
  end
end
