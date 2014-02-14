class OrderItem < ActiveRecord::Base
  belongs_to :book, :inverse_of => :order_items
  belongs_to :order, :inverse_of => :order_items
  
  validate :book_should_be_in_stock
  
  def title
    "#{book.title}, Quantity: #{quantity.to_s}"
  end
  
  private 
  
  def book_should_be_in_stock
    if book.in_stock < quantity
      errors.add(:book, "are not in stock")
    end
  end
end
