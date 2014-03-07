class CustomersController < ApplicationController
  before_filter :authenticate_customer!
  authorize_resource
  
  def show
    @wished_books = current_customer.wished_books.decorate
  end
  
end
