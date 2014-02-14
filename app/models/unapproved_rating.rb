class UnapprovedRating < Rating
  default_scope { where(state: "pending") }

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
      field :id
      field :state, :state do
        
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
