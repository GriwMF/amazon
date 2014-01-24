class Customer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable
  has_many :ratings
  has_many :credit_cards
  has_many :orders
  
  #validates :firstname, :lastname, presence: true
  #validates :email, uniqueness: true
  
  def admin?
    admin
  end
end
