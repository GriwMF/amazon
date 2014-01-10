require 'spec_helper'

describe Order do
  let(:order) { FactoryGirl.create :order }
  
  it "validates presence of total price" do
    expect(order).to validate_presence_of(:total_price)
  end
  
  it "has many books through order_items" do
    expect(order).to have_many(:books).through(:order_items)
  end
  
  it "belongs to customer" do
    expect(order).to belong_to(:customer)
  end

  it "billing address belongs to address" do
    expect(order).to belong_to(:bill_addr).class_name("Address")
  end  
  
  it "shipping address belongs to address" do
    expect(order).to belong_to(:ship_addr).class_name("Address")
  end  

  it "has one credit card" do
    expect(order).to have_one(:credit_card)
  end    
  
  it "has many order items, dependent destroy" do
    expect(order).to have_many(:order_items).dependent(:destroy)
  end    
  
  describe "order_items methods" do
    let(:order) { FactoryGirl.create(:order_with_items) }
    let(:book) { FactoryGirl.create(:book) }

    context "#refresh_prices" do
      before { order.refresh_prices }
      
      it "updates total_price" do
        expect(Order.find(order).total_price).to eq(15)
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
      
      it "saves proper quantity" do
        order.add_item(book, quantity: 21)
        expect(OrderItem.last.quantity).to eq(21)
      end
      
      it "asociate item with order" do
        order.add_item(book)
        expect(OrderItem.last.order).to eq(order)
      end
      
      it "increses quantity if order exist" do
        order.add_item(book)
        expect { order.add_item(book, quantity: 5) }.to change { order.order_items.find_by_book_id(book).quantity }.by(5)
      end
    end
    
    context "#refresh_in_stock" do
      it "change in_stock for purchaced books" do
        order.refresh_in_stock
        expect(order.order_items[0].book.in_stock).to eq(2)
        expect(order.order_items[1].book.in_stock).to eq(2)
        expect(order.order_items[2].book.in_stock).to eq(2)
      end
      
      it "raise error if no book in stock and rollback changes" do
        order.add_item(book, quantity: 4)
        expect { order.refresh_in_stock }.to raise_error(ActiveRecord::RecordInvalid)    
        expect(order.order_items[0].book.in_stock).to eq(3)   
      end
    end
    
    context "#complete_order" do
      before do
        allow(order).to receive(:refresh_in_stock)
        allow(order).to receive(:refresh_prices)
      end
      
      it "calls #refresh_prices" do
        expect(order).to receive(:refresh_prices)
        order.complete_order
      end
      
      it "calls #refresh_in_stock" do
        expect(order).to receive(:refresh_in_stock)
        order.complete_order
      end

      it "change completed_at to now" do
        expect { order.complete_order }.to change { order.completed_at }
      end
      
      it "change state to 'Processing'" do
        expect { order.complete_order }.to change { order.state }.to("Processing")
      end
      
    end

  end
end
