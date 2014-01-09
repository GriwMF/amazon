class Order < ActiveRecord::Base
  belongs_to :customer
  belongs_to :bill_addr, class_name: "Address"
  belongs_to :ship_addr, class_name: "Address"
  has_many :order_items
  has_many :books, through: :order_items
  has_one :credit_card
  
  validates :total_price, presence: true
  
  def add_item(book, quantity: 1)
    if ord = order_items.find_by_book_id(book)
      ord.quantity += quantity
      ord.save
    else
      order_items.create(book: book, quantity: quantity)
    end
  end
  
  def refresh_prices
    orders = order_items.includes(:book)
    sum = 0
    orders.each do |t|
      t.price = t.book.price
      sum += t.price * t.quantity
      t.save
    end
    self.total_price = sum
    save
  end
end
