class Book < ActiveRecord::Base
  belongs_to :author
  belongs_to :category
  has_many :ratings
  has_many :order_items
  
  validates :title, presence: true
  validates :in_stock,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
