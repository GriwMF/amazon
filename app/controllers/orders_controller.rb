class OrdersController < ApplicationController
  before_filter :authenticate_customer!, 
                except: [:cart, :add_item, :remove_item, :update, :destroy]
  authorize_resource
  
  before_action :set_order, only: [:show]
  #before_action :set_step, only: [:addresses, :check_out_1, check_out_2, check_out_3, check_out_4]

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

  # PATCH /orders/
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
      prepare_check_out
      render 'check_out_1'
    else
      redirect_to cart_orders_path
    end
  end

  # POST /orders/check_out
  def check_out
    @order = current_cart
    if params['state']
      @state = params['state'].to_i
    else
      prepare_check_out
    end
    #
    #case @state
    #  when 1
    #    prepare_check_out
    #end
    render "orders/check_out/check_out_#{@state}"
  end

  def check_out_1
    set_step
  end

  def check_out_2
    set_step
  end

  # PATCH /orders/addresses
  def addresses
    set_step
    unless update_addresses
      flash.now[:danger] = @order.errors.full_messages
      render 'check_out_1'
      return
    end
    set_state(2)
  end

  # PATCH /orders/delivery
  def delivery
    set_step
    unless params['delivery']
      flash.now[:danger] = t('err_delivery')
      render 'check_out_2'
      return
    end
    @order.delivery = Delivery.find(params['delivery'])
    @order.save
    set_state(3)
  end

  # DELETE /orders
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

  private
    def set_state(current)
      @state = current if @state <= current
      render "check_out_#{@state}"
    end

    def set_step
      if params['state']
        @state = params['state'].to_i
        @order = current_cart
      else
        flash[:danger] = t('check_out_wrong_state')
        redirect_to cart_orders_path
      end
    end

    def set_order
      @order = current_customer.orders.find(params[:id])
      not_found unless @order.in_progress?
    end

    def prepare_check_out
      @state = 1
      @order.build_ship_addr(current_customer.ship_addr.try(:attributes)) unless @order.ship_addr
      @order.build_bill_addr(current_customer.bill_addr.try(:attributes)) unless @order.bill_addr
    end

    def update_addresses
      if params['bill-checkbox'] == '1'
        @order.update_attributes(bill_addr_attributes: ship_addr_params, ship_addr_attributes: ship_addr_params)
      else
        @order.update_attributes(addresses_params)
      end
    end

    def addresses_params
      params.require(:order).permit(bill_addr_attributes: [:country, :address, :zipcode, :city, :phone],
                                     ship_addr_attributes: [:country, :address, :zipcode, :city, :phone])
    end

    def ship_addr_params
      params.require(:order).require(:ship_addr_attributes).permit(:country, :address, :zipcode, :city, :phone)
    end

    def ship_params
      
    end

    def order_params
      params.require(:order).permit(order_items_attributes: [ :id, :quantity])
    end

    def credit_card_params
      params.require(:order).require(:credit_card).permit(:firstname, :lastname, :number, :cvv, :expiration_month, :expiration_year)
    end    

end
