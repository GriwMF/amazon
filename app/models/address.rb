class Address < ActiveRecord::Base
  belongs_to :country
  has_many   :bill_orders, :foreign_key => 'bill_addr_id', :class_name => "Order"
  has_many   :ship_orders, :foreign_key => 'ship_addr_id', :class_name => "Order"
  
  validates :address, :city, :phone, presence: true
end
