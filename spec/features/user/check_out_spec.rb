require 'features/user_features_spec_helper'

feature "check out", js: true do
  given!(:book) { FactoryGirl.create :book }

  scenario "User complete purchase with entering all information manually" do
    visit books_path
    click_link book.title
    click_button I18n.t 'add_to_cart'
    click_link 'Cart'

    within("#check-out-ship") do
      click_link I18n.t 'or_add_new'
    end
    within("#check-out-ship-hidden") do
      fill_in 'order_ship_addr_country', :with => 'Ukraine'
      fill_in 'order_ship_addr_address', :with => '54 blablalba st, apt 666'
      fill_in 'order_ship_addr_zipcode', :with => '012574'
      fill_in 'order_ship_addr_city', :with => 'Kiev'
      fill_in 'order_ship_addr_phone', :with => '+38-097-542-36-54'
    end

    within("#check-out-bill") do
      click_link I18n.t 'or_add_new'
    end
    within("#check-out-bill-hidden") do
      fill_in 'order_bill_addr_country', :with => 'Ukraine'
      fill_in 'order_bill_addr_address', :with => '2 Kirova st, apt 3'
      fill_in 'order_bill_addr_zipcode', :with => '04534'
      fill_in 'order_bill_addr_city', :with => 'Kiev'
      fill_in 'order_bill_addr_phone', :with => '+38-093-544-32-11'
    end

    within("#check-out-card") do
      click_link I18n.t 'or_add_new'
    end
    within("#check-out-card-hidden") do
      fill_in 'order_credit_card_firstname', :with => 'Andrew'
      fill_in 'order_credit_card_lastname', :with => 'Griw'
      fill_in 'order_credit_card_number', :with => '1234' * 4
      fill_in 'order_credit_card_cvv', :with => '154'
      fill_in 'order_credit_card_expiration_month', :with => '11'
      fill_in 'order_credit_card_expiration_year', :with => Time.now.year + 1
    end

    click_button I18n.t 'check_out'

    expect(page).to have_content(I18n.t 'suc_ord_check_out')
  end
end