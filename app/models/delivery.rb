class Delivery < ActiveRecord::Base
  validates :title, :price, presence: true
end
