class Address < ActiveRecord::Base
  validates :country, :address, :city, :zipcode,:phone, presence: true
end
