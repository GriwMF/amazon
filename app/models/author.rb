class Author < ActiveRecord::Base
  #has_many :books, through: :authors_books
  has_and_belongs_to_many :books
  
  validates :firstname, :lastname, presence: true
end
