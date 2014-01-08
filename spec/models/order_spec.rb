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
  
  it "has many order items" do
    expect(order).to have_many(:order_items)
  end    
  
  describe "order_items methods" do
    let(:order) {FactoryGirl.create(:order_with_items)}

    context "#refresh_prices" do
      before { order.__send__(:refresh_prices) }
      
      it "updates total_price" do
        expect(Order.find(order).total_price).to eq(15)
      end
      
      it "updates prices in order_items" do
        
        expect(order.order_items[0].price).to eq(5)
      end
    end
    
    context "#add_item" do
      it "add one item" do
        expect { order.add_item(Book.first) }.to change { order.order_items.count}.by(1)
      end
      
      it "saves proper quantity" do
        order.add_item(Book.first, quantity: 21)
        expect(OrderItem.last.quantity).to eq(21)

      end
      
      it "asociate item with order" do
        order.add_item(Book.first)
        expect(OrderItem.last.order).to eq(order)        
      end
    end

  end
end
