class Customer < ActiveRecord::Base
  has_many :ratings
  has_many :credit_cards
  has_many :orders
  
  validates :firstname, :lastname, presence: true
  validates :email, uniqueness: true
  
end
