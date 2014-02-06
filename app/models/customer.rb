class Customer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :trackable, :recoverable, :validatable
  has_many :ratings, :inverse_of => :customer
  has_many :credit_cards, dependent: :destroy, :inverse_of => :customer
  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :destroy, :inverse_of => :customer
  has_and_belongs_to_many :wished_books, class_name: "Book"

  def cart
    orders.find_or_create_by(state: "in_progress")
  end

end
