class CustomersController < ApplicationController
  before_filter :authenticate_customer!
  authorize_resource
  
  def show
    
  end
  
end
