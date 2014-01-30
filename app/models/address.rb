class Address < ActiveRecord::Base
  has_many   :bill_orders, :foreign_key => 'bill_addr_id', :class_name => "Order"
  has_many   :ship_orders, :foreign_key => 'ship_addr_id', :class_name => "Order"
  
  validates :country, :address, :city, :phone, presence: true
  
  def full
    [country, city, address].join(" ")
  end
end
