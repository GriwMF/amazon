class CreditCard < ActiveRecord::Base
  belongs_to :customer
  belongs_to :order
  
  validates :firstname, :lastname, :cvv, presence: true
  validates :number, 
            length:  { is: 14 },
            presence: true
  validates :expiration_month,
            inclusion: { in: 1..12 },
            presence: true
  validates :expiration_year,
            presence: true
end
