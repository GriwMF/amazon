class Rating < ActiveRecord::Base
  belongs_to :book, :inverse_of => :ratings
  belongs_to :customer, :inverse_of => :ratings
  validates_inclusion_of :rating, in: 1..5

  validates_presence_of :title
  
  validates :book_id, uniqueness: { scope: :customer_id,
            message: "can't rate twice" }
  
  validates :state, inclusion: { in: %w(pending approved declined) }
  
  scope :approved, -> { where(state: "approved")  }
  
  state_machine :state, :initial => :pending do
    after_transition :on => :decline, :do => :destroy
    
    event :approve do
      transition :pending => :approved
    end
    
    event :decline do
      transition :pending => :declined
    end
  end

  rails_admin do
    list do
      sort_by :state
      field :id
      field :state, :state do
        sort_reverse true
      end
      include_all_fields
      # exclude_fields :id
    end
    
    show do
      field :state, :state
      include_all_fields
    end
    
    edit do
      field :state, :state
      include_all_fields      
    end    
    state({
     events: {decline: 'btn-danger', approve: 'btn-success'},
    })
  end
end
