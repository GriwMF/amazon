module CustomerCart
  extend ActiveSupport::Concern

  def current_cart
    if current_customer
      current_customer.cart
    else
      order = Order.where(id: cookies[:cart_name]).first
      if order.nil? || order.customer
        order = Order.create(state: 'in_progress')
        cookies[:cart_name] = order.id
      end
      order
    end
  end
end