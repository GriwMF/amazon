class Book < ActiveRecord::Base
  mount_uploader :shot, ShotUploader
  
  has_and_belongs_to_many :authors
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :wished_customers, class_name: "Customer"
  has_many :ratings, :inverse_of => :book
  has_many :order_items, :inverse_of => :book
  
  validates :title, presence: true
  validates :in_stock,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :top, -> { joins(:ratings).merge(Rating.approved).group('books.id')
                     .order("avg(rating) DESC").limit(5) }

  rails_admin do
    show do
      field :full_description do
        pretty_value do # used in list view columns and show views, defaults to formatted_value for non-association fields
          markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(:filter_html => true, :hard_wrap => true),
                                             :autolink => true, :space_after_headers => true, :strikethrough => true)
          markdown.render(value).html_safe
        end
      end
      include_all_fields      
    end
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
    ratings.where(state: "approved").average(:rating)
  end
  
  def unrated?(customer)
    ratings.where(customer_id: customer.id).count == 0
  end
end
