require 'features/features_spec_helper'

feature "check out" do
  given!(:book) { FactoryGirl.create :book }

  background do
    login_as(FactoryGirl.create(:customer), :scope => :customer)
    FactoryGirl.create :delivery
  end
  
  scenario "User complete purchase with entering all information manually" do
    visit books_path
    click_link book.title
    click_button I18n.t 'add_to_cart'
    click_link 'cart'
    click_button 'Checkout'

    select('Ukraine', :from => 'order_ship_addr_attributes_country')
    fill_in 'order_ship_addr_attributes_address', :with => '54 blablalba st, apt 666'
    fill_in 'order_ship_addr_attributes_zipcode', :with => '012574'
    fill_in 'order_ship_addr_attributes_city', :with => 'Kiev'
    fill_in 'order_ship_addr_attributes_phone', :with => '+38-097-542-36-54'

    check 'bill-checkbox'
    click_link_or_button 'SAVE AND CONTINUE'
    choose 'delivery_1'
    click_link_or_button 'SAVE AND CONTINUE'

    fill_in 'order_credit_card_attributes_number', :with => '1234' * 4
    fill_in 'order_credit_card_attributes_cvv', :with => '154'
    select('11', :from => 'order_credit_card_attributes_expiration_month')
    select(Time.now.year + 1, :from => 'order_credit_card_attributes_expiration_year')

    click_link_or_button 'SAVE AND CONTINUE'

    click_link_or_button 'PLACE ORDER'

    expect(page).to have_content('Continue shopping')
  end
end