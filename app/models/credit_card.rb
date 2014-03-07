class CreditCard < ActiveRecord::Base
  belongs_to :customer, :inverse_of => :credit_cards
  has_many :orders, :inverse_of => :credit_card
  
  validates :firstname, :lastname, :cvv, :number, presence: true
  validates_format_of  :number, with: /\A\d{16}\z/
  validates :expiration_month,
            inclusion: { in: 1..12 },
            presence: true
  validates :expiration_year,
            presence: true,
            inclusion: { in: Time.now.year..Time.now.year + 20 }
end
