class Order < ActiveRecord::Base
  belongs_to :customer, :inverse_of => :orders
  belongs_to :credit_card, :inverse_of => :orders
  belongs_to :bill_addr, class_name: "Address"
  belongs_to :ship_addr, class_name: "Address"
  has_many :order_items, dependent: :destroy, :inverse_of => :order
  
  has_many :books, through: :order_items

  scope :recent, -> { where("completed_at > ?", 3.month.ago).order("completed_at DESC") }
  scope :completed, -> { where.not(state: 'in_progress').order("completed_at DESC") }
  
  validates :state, inclusion: { in: %w(in_queue in_progress in_delivery delivered) }
  
  state_machine :initial => :in_progress do
    before_transition :on => :check_out!, :do => :complete_order!
    
    event :check_out! do
      transition :in_progress => :in_queue
    end
    
    event :ship do
      transition :in_queue => :in_delivery
    end
    
    event :complete_delivery do
      transition :in_delivery => :delivered
    end
  end
  
  rails_admin do
    list do
      filters [:state]
      field :id
      field :state do
        column_width 80
      end
      field :customer
      field :order_items
      field :completed_at
      #field :books
      # include_all_fields
      # exclude_fields :id
    end
    
    show do
      field :state, :state do
        visible do
          bindings[:object].state != "in_progress"
        end
      end
      include_all_fields      
    end

  end
  
  def add_item(book, quantity: 1)
    if order_item = order_items.find_by(book_id: book.id)
      order_item.quantity += quantity
      order_item.save
      order_item
    else
      order_items.create(book: book, quantity: quantity)
    end
  end

  def remove_item(item_id)
    order_items.find(item_id).destroy
  end
  
  def refresh_prices
    orderitems = order_items.includes(:book)
    sum = 0
    orderitems.each do |t|
      t.price = t.book.price
      sum += t.price * t.quantity
      t.save
    end
    self.total_price = sum
    save
  end
  
  def refresh_in_stock!
    Book.transaction do
      order_items.includes(:book).each do |order_item|
        order_item.book.in_stock -= order_item.quantity
        order_item.book.save!
      end
    end
  end
  
  def complete_order!
    refresh_in_stock!
    refresh_prices
    self.completed_at = DateTime.now
    save!
  end
end
