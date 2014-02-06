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

  config.label_methods |= [:full_name, :number, :email, :full]

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
    show_in_app
    state

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
