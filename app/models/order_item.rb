class OrderItem < ActiveRecord::Base
  belongs_to :book
  belongs_to :order
  
  validate :book_should_be_in_stock
  
  private def book_should_be_in_stock
    if book.in_stock <= 0
      errors.add(:book, "not in stock")
    end
  end
end
