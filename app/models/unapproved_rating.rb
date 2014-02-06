class UnapprovedRating < Rating
  default_scope where(approved: :false)

  state_machine :approved, :initial => :false do
    after_transition :on => :decline, :do => :destroy
    
    event :approve do
      transition :false => :true
    end
    
    event :decline do
      transition :false => :deleted
    end
  end

  rails_admin do
    list do
      field :id
      field :approved, :state do
        
      end
      include_all_fields
      # exclude_fields :id
    end
    
    show do
      field :approved, :state
      include_all_fields      
    end
    
    edit do
      field :approved, :state
      include_all_fields      
    end    
    state({
     events: {decline: 'btn-danger', approve: 'btn-success'},
    })
  end
end
