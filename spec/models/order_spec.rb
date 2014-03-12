require 'spec_helper'

describe Order do
  let(:order) { FactoryGirl.create :order }
  
  it "has many books through order_items" do
    expect(order).to have_many(:books).through(:order_items)
  end
  
  it "belongs to customer" do
    expect(order).to belong_to(:customer)
  end

  it "belongs to credit card" do
    expect(order).to belong_to(:credit_card)
  end    

  it "belongs to coupon" do
    expect(order).to belong_to(:coupon)
  end   
  
  it "has many order items, dependent destroy" do
    expect(order).to have_many(:order_items).dependent(:destroy)
  end
  
  its "state are in %w(in_queue in_progress in_delivery delivered)" do
    expect(order).to ensure_inclusion_of(:state).in_array(%w(in_queue in_progress in_delivery delivered))
  end

  context "recent scope" do
    it "includes order completed in last 3 months" do
      order = FactoryGirl.create :order, completed_at: 1.month.ago
      expect(Order.recent).to include order
    end
    
    it "excludes orders, completed earlier than 3 months ago" do
      order = FactoryGirl.create :order, completed_at: 4.month.ago
      expect(Order.completed).to_not include order      
    end
  end
 
   context "completed scope" do
    it "includes orders that are not in_progress" do
      order = FactoryGirl.create :order, state: 'delivered'
      expect(Order.completed).to include order
    end
    
    it "excludes orders which are in_progress" do
      order = FactoryGirl.create :order, state: 'in_progress'
      expect(Order.recent).to_not include order      
    end
  end

  describe "order_items methods" do
    let(:order) { FactoryGirl.create(:order_with_book_price_5_and_quantity_3) }
    let(:book) { FactoryGirl.create(:book, price: 7, in_stock: 50) }

    context "#refresh_prices" do
      before { order.refresh_prices }
      
      it "updates total_price" do
        expect(Order.find(order).total_price).to eq(45)
      end
      
      it "updates prices in order_items" do
        expect(order.order_items[0].price).to eq(5)
        expect(order.order_items[1].price).to eq(5)
        expect(order.order_items[2].price).to eq(5)
      end
    end
    
    context "#add_item" do
      
      it "add one item" do
        expect { order.add_item(book) }.to change { order.order_items.count}.by(1)
      end

      it 'calls refresh_prices' do
        expect(order).to receive(:refresh_prices)
        order.add_item(book)
      end
      
      it "saves proper quantity" do
        item = order.add_item(book, quantity: 21)
        expect(OrderItem.find(item).quantity).to eq(21)
      end
      
      it "asociate item with order" do
        item = order.add_item(book)
        expect(OrderItem.find(item).order).to eq(order)
      end
      
      it "increses quantity if order exist" do
        order.add_item(book)
        expect { order.add_item(book, quantity: 5) }.to change { order.order_items.find_by(book_id: book.id).quantity }.by(5)
      end
    end

    context "#remove_item" do
       it "removes item from order" do
        item = order.add_item(book)
        expect { order.remove_item(item) }.to change { order.order_items.count}.by(-1)
      end     
    end
    
    context "#refresh_in_stock!" do
      it "change in_stock for purchaced books" do
        order.refresh_in_stock!
        expect(order.order_items[0].book.in_stock).to eq(0)
        expect(order.order_items[1].book.in_stock).to eq(0)
        expect(order.order_items[2].book.in_stock).to eq(0)
      end
      
      it "raise error if no book in stock and rollback changes" do
        item = order.add_item(book, quantity: 4)
        book.in_stock = 3
        book.save
        expect { order.refresh_in_stock! }.to raise_error(ActiveRecord::RecordInvalid)    
        expect(item.book.in_stock).to eq(3)   
      end
    end
    
    context "#complete_order" do
      before do
        allow(order).to receive(:refresh_in_stock!)
        allow(order).to receive(:refresh_prices)
      end
      
      it "calls #refresh_prices!" do
        expect(order).to receive(:refresh_prices)
        order.complete_order!
      end
      
      it "calls #refresh_in_stock!" do
        expect(order).to receive(:refresh_in_stock!)
        order.complete_order!
      end

      it "change completed_at to now" do
        expect { order.complete_order! }.to change { order.completed_at }
      end
    end
  end
  
  describe "states" do
    before do
      allow(order).to receive(:complete_order!)
    end
    
    context "check_out" do
      it "changes state from in_progress to in_queue" do
        expect(order.state).to eq("in_progress")
        expect { order.check_out! }.to change { order.state }.to("in_queue")
      end
      
      it "calls #complete_order!" do
        expect(order).to receive(:complete_order!)
        order.check_out!
      end
    end
    
    context "ship" do
      it "changes state from in_queue to in_delivery" do
        order.check_out!
        expect { order.ship }.to change { order.state }.to("in_delivery")
      end
    end
    
    context "complete delivery" do
      it "changes state from in_deliver to delivered" do
        order.check_out!
        order.ship
        expect { order.complete_delivery }.to change { order.state }.to("delivered")
      end
    end
  end
end
