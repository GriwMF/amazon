module Concerns
  module SessionManagement
    extend ActiveSupport::Concern

    included do
      #before_filter :check_admin
    end
    
    private def check_admin
      redirect_to root_path unless customer_signed_in? && current_customer.admin?
    end
  end

end