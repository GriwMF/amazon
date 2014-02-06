class Address < ActiveRecord::Base
  has_many   :bill_orders, :foreign_key => 'bill_addr_id', :class_name => "Order", :inverse_of => :bill_addr
  has_many   :ship_orders, :foreign_key => 'ship_addr_id', :class_name => "Order", :inverse_of => :ship_addr
  
  validates :country, :address, :city, :phone, presence: true
  
  def full
    [country, city, address].join(" ")
  end
end
