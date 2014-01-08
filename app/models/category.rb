class Category < ActiveRecord::Base
  #has_many :books, through: :books_categories
  has_and_belongs_to_many :books
  
  validates :title, presence: true
end
