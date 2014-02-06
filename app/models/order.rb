class Order < ActiveRecord::Base
  belongs_to :customer, :inverse_of => :orders
  belongs_to :credit_card, :inverse_of => :orders
  belongs_to :bill_addr, class_name: "Address", :inverse_of => :bill_orders
  belongs_to :ship_addr, class_name: "Address", :inverse_of => :ship_orders
  has_many :order_items, dependent: :destroy, :inverse_of => :order
  has_many :books, through: :order_items
  
  validates :state, inclusion: { in: %w(processing selecting shipped cancelled) }
  
  state_machine :initial => :selecting do
    before_transition :on => :check_out!, :do => :complete_order!
    
    event :check_out! do
      transition :selecting => :processing
    end
    
    event :ship do
      transition :processing => :shipped
    end
    
    event :cancel do
      transition :processing => :cancelled
    end
  end
  
  def add_item(book, quantity: 1)
    if order_item = order_items.find_by(book_id: book.id)
      order_item.quantity += quantity
      order_item.save
      order_item
    else
      order_items.create(book: book, quantity: quantity)
    end
  end
  
  def refresh_prices
    orderitems = order_items.includes(:book)
    sum = 0
    orderitems.each do |t|
      t.price = t.book.price
      sum += t.price * t.quantity
      t.save
    end
    self.total_price = sum
    save
  end
  
  def refresh_in_stock!
    Book.transaction do
      order_items.includes(:book).each do |order_item|
        order_item.book.in_stock -= order_item.quantity
        order_item.book.save!
      end
    end
  end
  
  def complete_order!
    refresh_in_stock!
    refresh_prices
    self.completed_at = DateTime.now
    save!
  end
end
