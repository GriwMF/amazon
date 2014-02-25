class Address < ActiveRecord::Base
  validates :country, :address, :city, :phone, presence: true
  
  def full
    [country, city, address].join(" ")
  end
end
