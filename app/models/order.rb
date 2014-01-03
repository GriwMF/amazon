class Order < ActiveRecord::Base
  belongs_to :customer
  belongs_to :bill_addr, class_name: "Address"
  belongs_to :ship_addr, class_name: "Address"
  has_many :order_items
  has_many :books, through: :order_item
  has_one :credit_card
  
  validates :total_price, presence: true
end
