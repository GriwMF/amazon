class Customer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :trackable, :recoverable, :validatable
  has_many :ratings, :inverse_of => :customer
  has_many :credit_cards, :inverse_of => :customer
  has_many :addresses
  has_many :orders, :inverse_of => :customer
  has_and_belongs_to_many :wished_books, class_name: "Book"

  def cart
    orders.find_or_create_by(state: "selecting")
  end

end
