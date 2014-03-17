require "spec_helper"

describe ApplicationHelper do
  describe "#render_cart" do
    let (:order) { mock_model(Order, order_items: {}) }

    it "calls current_cart" do
      expect(helper).to receive(:current_cart).and_return(order)
      helper.render_cart
    end

    it 'renders html for empty cart if no order_items' do
      allow(helper).to receive(:current_cart).and_return(order)
      expect(helper.render_cart).to eq("<div id='empty_cart'><span class='glyphicon glyphicon-shopping-cart'></span><br> #{t('empty_cart')}</div>".html_safe)
    end

    it 'renders html for cart if order_items' do
      full_order = mock_model(Order, order_items: { any?: true }, total_price: 10)
      allow(full_order.order_items).to receive(:sum).and_return(5)
      allow(helper).to receive(:current_cart).and_return(full_order)
      expect(helper.render_cart).to eq("<a href=\"/orders/cart\" id=\"cart\"><span class='glyphicon glyphicon-shopping-cart'></span>(5) <br> $10.00</a>".html_safe)
    end
  end
end