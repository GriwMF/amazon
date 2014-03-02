class OrdersController < ApplicationController
  before_filter :authenticate_customer!
  authorize_resource
  
  before_action :set_order, only: [:show, :update]
  
  # GET /orders
  # GET /orders.json
  def index
    @orders = current_customer.orders.completed.page(params[:page]).decorate
  end
  
  # GET /orders/recent
  def recent
    @orders = current_customer.orders.recent.page(params[:page]).decorate
    render :index
  end  
  
  # GET /orders/1
  # GET /orders/1.json
  def show
    @order = @order.decorate
    @addresses = current_customer.addresses.decorate
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
      @order.check_out!
      flash_message :success, I18n.t('suc_ord_check_out')                             
      
    rescue ActiveRecord::RecordInvalid => ex
      flash_message :danger, ex.message
    rescue ActiveRecord::StatementInvalid => ex
      flash_message :danger, ex.message
      flash_message :danger, I18n.t('err_ord_check_out') 
    end
    redirect_to root_path
  end
  
  # POST /orders/add_item/1
  def add_item
    book = Book.find(params[:id])
    item = current_cart.add_item(book, quantity: params[:quantity].to_i)
    if item.errors.any?
      flash[:danger] =item.errors.full_messages
    else
      flash[:info] = I18n.t 'suc_book_added'
      current_cart.refresh_prices
    end
    redirect_to :back
  end

  # DELETE /orders/remove_item/1
  def remove_item
    current_cart.remove_item(params[:id])
    redirect_to :back
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = current_customer.orders.find(params[:id])
      not_found unless @order.in_progress?
    end

    def current_cart
      current_customer.cart
    end

    def ship_addr_params
      params.require(:order).require(:ship_addr).permit(:country, :address, :zipcode, :city, :phone)
    end
    
    def bill_addr_params
      params.require(:order).require(:bill_addr).permit(:country, :address, :zipcode, :city, :phone)
    end

    def credit_card_params
      params.require(:order).require(:credit_card).permit(:firstname, :lastname, :number, :cvv, :expiration_month, :expiration_year)
    end    

end
