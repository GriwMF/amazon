class OrdersController < ApplicationController
  include Concerns::SessionManagement
    
  before_action :set_order, only: [:show, :update]
  before_filter :authenticate_customer!
  before_filter :check_admin, only: [:ship, :cancel]

  # GET /orders
  # GET /orders.json
  def index
    @orders = if current_customer.admin?
                Order.where(state: "processing")
              else
                current_customer.orders.where("completed_at > ?", 3.month.ago).order("completed_at DESC")
              end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  #PATCH /orders/1
  def update
    begin
      if (ship_addr = params[:order][:ship_addr_id]).empty?
        ship_addr = Address.create!(ship_addr_params).id
      end

      if params['bill-checkbox']
        bill_addr = ship_addr
      else
        if (bill_addr = params[:order][:bill_addr_id]).empty?
          bill_addr = Address.create!(bill_addr_params).id
        end
      end

      if (credit_card = params[:order][:credit_card_id]).empty?
        credit_card = CreditCard.create!(credit_card_params).id
      end
      
      @order.update_attributes!(ship_addr_id: ship_addr,
                               bill_addr_id: bill_addr,
                               credit_card_id: credit_card)
      @order.complete_order!
      flash_message :success, 'Success! Your order is under processing.'                               
      
    rescue ActiveRecord::RecordInvalid => ex
      flash_message :danger, ex.message
      flash_message :danger, "Propably not enought books in stock or wrong fields filled :("
    end
    redirect_to root_path
  end
  
  def add_item
    book = Book.find(params[:id])
    if (err = current_customer.cart.add_item(book).errors).any?
      flash[:danger] =err.full_messages
    else
      flash[:info] = "Book was successefully added"
      current_customer.cart.refresh_prices
    end
    redirect_to books_path
  end

  def remove_item
    current_customer.cart.order_items.find(params[:id]).destroy
    redirect_to :back
  end
  
  #PATCH /orders/1/ship
  def ship
    Order.find(params[:id]).update(state: "shipped")
    redirect_to orders_path
  end
  
  #PATCH /orders/1/cancel
  def cancel
    Order.find(params[:id]).update(state: "cancelled")
    redirect_to orders_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = current_customer.orders.find(params[:id])
      not_found unless @order.state == "selecting"
    end
    
    def ship_addr_params
      params.require(:order).require(:ship_addr).permit(:country, :address, :zipcode, :city, :phone)
    end
    
    def bill_addr_params
      params.require(:order).require(:bill_addr).permit(:country, :address, :zipcode, :city, :phone)
    end

    def credit_card_params
      params.require(:order).require(:bill_addr).permit(:firstname, :lastname, :number, :cvv, :expiration_month, :expiration_year)
    end    

end
