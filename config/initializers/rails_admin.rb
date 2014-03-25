RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
    # warden.authenticate! scope: :admin
  # end
  config.current_user_method(&:current_customer)

  ## == Cancan ==
  config.authorize_with :cancan

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.label_methods |= [:number, :email]

  config.model 'OrderItem' do
    object_label_method do
      :custom_label_method
    end
  end

  config.model 'Author' do
    object_label_method do
      :author_full_name
    end    
  end

  config.model 'Address' do
    object_label_method do
      :full_address
    end    
  end

  def custom_label_method
    "#{book.title}, Quantity: #{quantity.to_s}"
  end

  def author_full_name
    decorate.full_name
  end

  def full_address
    decorate.full
  end

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new do
      except [Order]
    end
    export
    bulk_delete do
      except [Order]
    end
    show
    edit do
      except [Order]
    end
    delete do
      except [Order]
    end
    show_in_app do
      except [Order, Customer]
    end
    state

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
