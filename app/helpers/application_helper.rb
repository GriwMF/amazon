module ApplicationHelper
  include CustomerCart

  def render_cart
    order = current_cart
    if order.order_items.any?
      number = "(#{order.order_items.sum(:quantity)})"
      price = number_to_currency(order.total_price)
      link_to "<span class='glyphicon glyphicon-shopping-cart'></span>#{number} <br> #{price}".html_safe,
              cart_orders_path, id: 'cart'
    else
      "<div id='empty_cart'><span class='glyphicon glyphicon-shopping-cart'></span><br> #{t('empty_cart')}</div>".html_safe
    end
  end
end
