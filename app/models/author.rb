class Author < ActiveRecord::Base
  has_and_belongs_to_many :books
  
  validates :firstname, :lastname, presence: true
  
  def full_name
    "#{firstname} #{lastname}"
  end
end
