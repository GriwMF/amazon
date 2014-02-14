class Rating < ActiveRecord::Base
  belongs_to :book, :inverse_of => :ratings
  belongs_to :customer, :inverse_of => :ratings
  validates_inclusion_of :rating, in: 1..5
  
  validates :book_id, uniqueness: { scope: :customer_id,
            message: "can't rate twice" }
  
  validates :state, inclusion: { in: %w(pending approved declined) }
  
  # validate :rate_book_only_once
#   
  # def rate_book_only_once
    # rate = Rating.find_by(book_id: book_id, customer_id: customer_id)
    # errors.add(:book_id, "already rated") if rate
  # end
end
