class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :destroy]
  before_filter :authenticate_customer!

  # GET /orders
  # GET /orders.json
  def index
    @orders = current_customer.orders.where("completed_at > ?", 3.month.ago)
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
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
  
  def check_out
    order = current_customer.orders.find_by(state: "selecting")
    begin
      order.update_attributes!(ship_addr_id: params[:ship_addr][:id],
                               bill_addr_id: params[:bill_addr][:id],
                               credit_card_id: params[:credit_card][:id])
      order.complete_order!
      flash_message :success, 'Success! Your order is under processing.'
    rescue ActiveRecord::RecordInvalid => ex
      flash_message :danger, ex.message
      flash_message :danger, "Propably not enought books in stock :("
    end
    redirect_to root_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = current_customer.orders.find(params[:id])
     # not_found unless current_customer.orders.find(@order)
    end
end
