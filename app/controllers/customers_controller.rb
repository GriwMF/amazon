class CustomersController < ApplicationController
  before_filter :authenticate_customer!
  authorize_resource
  
  def show
    
  end
  
  def edit
    
  end
  
  def update
    respond_to do |format|
      if current_customer.update(customer_params)
        format.html { redirect_to customer_path, notice: 'Profile was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end
  
  private
  
  def customer_params
    params.require(:customer).permit(:firstname, :lastname)
  end
end
