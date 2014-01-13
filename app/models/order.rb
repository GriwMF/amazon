class Order < ActiveRecord::Base
  belongs_to :customer
  belongs_to :credit_card
  belongs_to :bill_addr, class_name: "Address"
  belongs_to :ship_addr, class_name: "Address"
  has_many :order_items, dependent: :destroy
  has_many :books, through: :order_items
  
  validates :total_price, presence: true
  
  def add_item!(book, quantity: 1)
    if order_item = order_items.find_by(book_id: book.id)
      order_item.quantity += quantity
      order_item.save
      order_item
    else
      order_items.create(book: book, quantity: quantity)
    end
  end
  
  def refresh_prices!
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
  
  def complete_order
    refresh_in_stock!
    refresh_prices!
    self.state = "processing"
    self.completed_at = DateTime.now
    save!
  end
end
