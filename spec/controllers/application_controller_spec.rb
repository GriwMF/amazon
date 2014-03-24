require 'spec_helper'


describe ApplicationController do
  
  describe "protected methods" do
    it "#not_found raise RoutingError" do
      expect { @controller.send(:not_found) }.to raise_error ActionController::RoutingError
    end
    
    it "#flash_message creates array of flash" do
      @controller.send(:flash_message, :notice, "haha")
      @controller.send(:flash_message, :notice, "next")
      expect(flash[:notice]).to eq(["haha", "next"])
    end

    describe '#process_order' do
      context 'does nothing' do
        it 'when no order found' do
          Order.stub_chain(:where, :first).and_return(nil)
          expect(Order).to_not receive(:save)
          @controller.send(:process_order)
        end

        it 'when no order_items found' do
          Order.stub_chain(:where, :first).and_return(mock_model(Order, order_items: []))
          expect(Order).to_not receive(:save)
          @controller.send(:process_order)
        end

        it 'when order already belongs to customer' do
          order = mock_model(Order, customer: 5, order_items: [5]) 
          Order.stub_chain(:where, :first).and_return(order)
          expect(Order).to_not receive(:save)
          @controller.send(:process_order)
        end
      end

      context 'when everything is ok' do
        let(:order) { FactoryGirl.create :order, customer: nil }
        let(:customer) { FactoryGirl.create :customer }

        before do
          cookies[:cart_name] = order.id
          allow(@controller).to receive(:current_customer).and_return(customer)
          FactoryGirl.create :order_item, order: order
        end

        it 'delete old order' do
          old_order = FactoryGirl.create :order, customer: customer, state: 'in_progress'
          @controller.send(:process_order)
          expect(customer.orders).to_not include(old_order)
        end

        it 'assign customer to order' do
          @controller.send(:process_order)
          expect(Order.find(order).customer).to eq(customer)
        end

        it 'clears cookie' do
          @controller.send(:process_order)
          expect(cookies[:cart_name]).to be_nil
        end

      end 
    end
  end
end