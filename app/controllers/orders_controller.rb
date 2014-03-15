class OrdersController < ApplicationController
  before_filter :authenticate_customer!, 
                except: [:cart, :add_item, :remove_item, :update, :destroy]
  authorize_resource
  
  before_action :set_order, only: [:show]
  before_action :set_step, only: [:addresses, :check_out, :credit_card, :delivery]

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
    else
      redirect_to cart_orders_path
    end
  end

  # POST /orders/check_out/1
  def check_out
    @order.build_credit_card unless params[:step] != '3' || @order.credit_card
    @order.refresh_prices if  params[:step] == '4'
    render "orders/check_out/check_out_#{params[:step]}"
  end

  # PATCH /orders/addresses
  def addresses
    unless update_addresses
      flash.now[:danger] = @order.errors.full_messages
      render 'orders/check_out/check_out_1'
      return
    end
    update_customer_addresses
    set_state_and_redirect(2)
  end

  # PATCH /orders/delivery
  def delivery
    unless params['delivery']
      flash[:danger] = t('err_delivery')
      redirect_to '/orders/check_out/2'
      return
    end
    @order.delivery = Delivery.find(params['delivery'])
    @order.save
    set_state_and_redirect(3)
  end

  # PATCH /orders/credit_card
  def credit_card
    unless @order.update_attributes(credit_card_params)
      flash[:danger] = @order.errors.full_messages
      redirect_to '/orders/check_out/3'
      return
    end
    set_state_and_redirect(4)
  end

  # GET /orders/complete
  def complete
    unless session['state'] == 4
      flash[:danger] = t('check_out_wrong_state')
      redirect_to cart_orders_path
      return
    end
    @order = current_cart
    @order.check_out!
    session.delete 'state'
    render 'complete'
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
    def set_state_and_redirect(current)
      @state = current if @state <= current
      session['state'] = @state
      redirect_to "/orders/check_out/#{@state}"
    end

    def set_step
      if session['state']
        @state = session['state'].to_i
        @order = current_cart
      else
        flash[:danger] = t('check_out_wrong_state')
        redirect_to cart_orders_path
        false
      end
    end

    def set_order
      @order = current_customer.orders.find(params[:id])
    end

    def prepare_check_out
      @state = session['state'] ||= 1
      if @state > 1
        redirect_to "/orders/check_out/#{@state}"
      else
        unless @order.ship_addr
          if current_customer.ship_addr
            @order.ship_addr = current_customer.ship_addr.dup
          else
            @order.build_ship_addr
          end
        end

        unless @order.bill_addr
          if current_customer.bill_addr
            @order.bill_addr = current_customer.bill_addr.dup
          else
            @order.build_bill_addr
          end
        end

        render 'orders/check_out/check_out_1'
      end
    end

    def update_addresses
      if params['bill-checkbox'] == '1'
        @order.update_attributes(ship_addr_attributes: ship_addr_params,
                                  bill_addr_attributes: ship_addr_params.merge(
                                                         id: params['order']['bill_addr_attributes'][:id]))
      else
        @order.update_attributes(addresses_params)
      end
    end

    def update_customer_addresses
      current_customer.ship_addr ||= @order.ship_addr.dup
      current_customer.bill_addr ||= @order.bill_addr.dup
      current_customer.save
    end

    def addresses_params
      params.require(:order).permit(bill_addr_attributes: [:id, :country, :address, :zipcode, :city, :phone],
                                     ship_addr_attributes: [:id, :country, :address, :zipcode, :city, :phone])
    end

    def ship_addr_params
      params.require(:order).require(:ship_addr_attributes).permit(:id, :country, :address, :zipcode, :city, :phone)
    end

    def order_params
      params.require(:order).permit(order_items_attributes: [:id, :quantity])
    end

    def credit_card_params
      params.require(:order).permit(credit_card_attributes: [:id, :number, :cvv, :expiration_month, :expiration_year])
    end    

end
