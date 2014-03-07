class Address < ActiveRecord::Base
  validates :country, :address, :city, :phone, presence: true
  
end
