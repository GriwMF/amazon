require 'features/features_spec_helper'

feature "all orders" do
  let(:user) { FactoryGirl.create :customer }

  background do
    login_as(user, :scope => :customer)
  end

  scenario "user viewing all orders in history" do
    order = FactoryGirl.create :order_with_book_price_5_and_quantity_3, state: 'in_queue',
                               customer_id: user.id, completed_at: 5.month.ago
    visit books_path
    click_link I18n.t('history')
    click_link I18n.t('all_orders')
    expect(page).to have_content order.order_items[0].book.title
  end 
end
    