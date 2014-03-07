module ApplicationHelper
  include CustomerCart

  def render_cart
    order = current_cart
    if order.order_items.any?
      number = "(#{order.order_items.sum(:quantity)})"
      price = "$#{order.total_price}"
    else
      number = ''
      price = t('empty_cart')
    end

    link_to "<span class='glyphicon glyphicon-shopping-cart'></span>#{number} <br> #{price}".html_safe,
            orders_path, id: 'cart'
  end
end
