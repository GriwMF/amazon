require 'features/features_spec_helper'

feature "recent orders" do
  let(:user) { FactoryGirl.create :customer }

  background do
    login_as(user, :scope => :customer)
  end

  scenario "user viewing recent orders" do
    delivery = FactoryGirl.create :delivery
    order = FactoryGirl.create :order_with_book_price_5_and_quantity_3, customer_id: user.id,
                                 completed_at: Time.now, state: "in_queue", delivery_id: delivery.id, total_price: 10
    visit books_path
    click_link I18n.t('history')
    click_link I18n.t('recent_orders')
    expect(page).to have_content "R#{order.id}"
  end

  scenario "user does not seen old orders in recent" do
    order = FactoryGirl.create :order_with_book_price_5_and_quantity_3, customer_id: user.id,
                                 completed_at: 5.month.ago, state: "in_queue"
    visit books_path
    click_link I18n.t('history')
    click_link I18n.t('recent_orders')
    expect(page).to_not have_content "R#{order.id}"
  end 
end
    