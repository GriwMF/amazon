class Rating < ActiveRecord::Base
  belongs_to :book
  belongs_to :customer
  validates_inclusion_of :rating, in: 1..5
  
  validate :rate_book_only_once
  
  def rate_book_only_once
    rate = Rating.find_by(book_id: book_id, customer_id: customer_id)
    errors.add(:book_id, "already rated") if rate
  end
end
