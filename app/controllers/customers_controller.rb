class CustomersController < ApplicationController
  before_filter :authenticate_customer!
  authorize_resource

  before_action :assign_wished, only: [:ship_create, :bill_create, :show]

  def show
  end

  def ship_create
    address = current_customer.build_ship_addr(address_params)

    if address.save
      current_customer.save
      redirect_to customer_path
    else
      flash.now[:danger] = address.errors.full_messages
      render :show
    end
  end

  def ship_update
    flash[:danger] = current_customer.ship_addr.errors.full_messages unless current_customer.ship_addr.update(address_params)
    redirect_to customer_path
  end

  def bill_create
    address = current_customer.build_bill_addr(address_params)
    if address.save
      current_customer.save
      redirect_to customer_path
    else
      flash.now[:danger] = address.errors.full_messages
      render :show
    end
  end

  def bill_update
    flash[:danger] = current_customer.bill_addr.errors.full_messages unless current_customer.bill_addr.update(address_params)
    redirect_to customer_path
  end

  private

  def assign_wished
    @wished_books = current_customer.wished_books.decorate
  end

  def address_params
    params.require(:address).permit(:country, :address, :zipcode, :city, :phone)
  end
end
