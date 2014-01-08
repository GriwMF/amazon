class Book < ActiveRecord::Base
  # has_many :authors, through: :authors_books
  # has_many :categories, through: :books_categories
  has_and_belongs_to_many :authors
  has_and_belongs_to_many :categories
  has_many :ratings
  has_many :order_items
  
  validates :title, presence: true
  validates :in_stock,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
