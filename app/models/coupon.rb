class Coupon < ActiveRecord::Base
  validates :code, :discount, presence: true
  
end
