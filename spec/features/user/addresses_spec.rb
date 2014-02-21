require 'features/features_spec_helper'

feature "Address management" do

  let(:user) { FactoryGirl.create :customer }

  background do
    login_as(user, :scope => :customer)
  end

  scenario "User adds new address to account" do
    visit books_path
    click_link I18n.t 'profile'
    click_link I18n.t 'addresses'
    click_link I18n.t 'new_address'

    within("#new_address") do
      fill_in 'address_country', :with => 'Ukraine'
      fill_in 'address_address', :with => '54 blablalba st, apt 666'
      fill_in 'address_zipcode', :with => '012574'
      fill_in 'address_city', :with => 'Kiev'
      fill_in 'address_phone', :with => '+38-097-542-36-54'

      click_button I18n.t 'save'
    end

    expect(page).to have_content 'Ukraine'
    expect(page).to have_content '+38-097-542-36-54'
  end

  scenario "User edits zipcode of existing address" do 
    FactoryGirl.create :address, customer_id: user.id
    visit books_path
    click_link I18n.t 'profile'
    click_link I18n.t 'addresses'
    click_link I18n.t 'edit'   

    within(".edit_address") do
      fill_in 'address_zipcode', :with => '12543'

      click_button I18n.t 'save'
    end

    expect(page).to have_content '12543'
  end
end