class OrdersController < ApplicationController
  before_filter :authenticate_customer!, 
                except: [:cart, :add_item, :remove_item, :update, :destroy]
  authorize_resource
  
  before_action :set_order, only: [:show]

  include CustomerCart
  
  # GET /orders
  def index
    @orders = current_customer.orders.completed.page(params[:page]).decorate
  end
  
  # GET /orders/recent
  def recent
    @orders = current_customer.orders.recent.page(params[:page]).decorate
    render :index
  end

  # GET /orders/1
  def show
    raise "NOOOOOOO~!!!"
  end

  # GET /orders/cart
  def cart
    @order = current_cart.decorate
  end

  #PATCH /orders/
  def update
    @order = current_cart
    unless @order.update_attributes(order_params)
      flash[:danger] = @order.errors.full_messages
      redirect_to cart_orders_path
      return
    end
    @order.refresh_prices

    if c = Coupon.where(code: params['coupon_code']).first
      @order.coupon = c
      @order.save
    else
      flash[:danger] = I18n.t('wrong_coupon')
    end unless params['coupon_code'].blank?

    if params['commit'] == I18n.t('check_out')
      @state = 1
      
      render :check_out_1
    else
      redirect_to cart_orders_path
    end
  end
 
  #PATCH /orders/addresses
  def addresses
    @order = current_cart
    @state = 3
    render :check_out_1
  end

  #DELETE /orders
  def destroy
    current_cart.order_items.delete_all
    current_cart.refresh_prices
    flash[:success] = I18n.t('cart_cleaned')
    redirect_to books_path
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
    redirect_to cart_orders_path
  end

  # DELETE /orders/remove_item/1
  def remove_item
    current_cart.remove_item(params[:id])
    current_cart.refresh_prices
    redirect_to :back
  end

  # GET /orders/check_out_1
  def check_out_1
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = current_customer.orders.find(params[:id])
      not_found unless @order.in_progress?
    end

    def addresses_params
      
    end

    def ship_params
      
    end

    def order_params
      params.require(:order).permit(order_items_attributes: [ :id, :quantity])
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
