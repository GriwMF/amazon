class Book < ActiveRecord::Base
  has_and_belongs_to_many :authors
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :wished_customers, class_name: "Customer"
  has_many :ratings, :inverse_of => :book
  has_many :order_items, :inverse_of => :book
  
  validates :title, presence: true
  validates :in_stock,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
      
  def self.filter(authors_id, categories_id, books_id)
    relation = Book.includes(:authors, :categories)
    
    relation = relation.where(id: books_id) if books_id.any?
    relation = relation.where(authors: { id: authors_id } ) if authors_id.any?
    relation = relation.where(categories: { id: categories_id} ) if categories_id.any?
    relation
  end
      
            
  def wished
    wished_customers.count
  end
  
  def wished_by?(customer)
    wished_customers.include? customer
  end
  
  def wish_add(customer)
    self.wished_customers << customer unless wished_by?(customer)
  end
  
  def rating
    ratings.where(approved: true).average(:rating)
  end
  
  def unrated?(customer)
    ratings.where(customer_id: customer.id).count == 0
  end
  

end
