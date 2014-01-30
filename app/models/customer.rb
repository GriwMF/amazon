class Customer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable
  has_many :ratings
  has_many :credit_cards
  has_many :addresses
  has_many :orders
  has_and_belongs_to_many :wished_books, class_name: "Book"

  def cart
    orders.find_or_create_by(state: "selecting")
  end

  def admin?
    admin
  end
end
