require 'features/features_spec_helper'

feature "Address management" do

  let(:user) { FactoryGirl.create :customer }

  background do
    login_as(user, :scope => :customer)
  end

  scenario "User adds new address to account" do
    user.bill_addr.destroy
    visit books_path
    click_link I18n.t 'profile'

    within("#new_address") do
      select('Ukraine', :from => 'address_country')
      fill_in 'address_address', :with => '54 blablalba st, apt 666'
      fill_in 'address_zipcode', :with => '012574'
      fill_in 'address_city', :with => 'Kiev'
      fill_in 'address_phone', :with => '+38-097-542-36-54'

      click_button I18n.t 'save'
    end

    expect(page).to have_field('address_country', with: 'Ukraine')
    expect(page).to have_field('address_phone', with: '+38-097-542-36-54')
  end

  scenario "User edits zipcode of existing address" do
    user.bill_addr.destroy
    visit books_path
    click_link I18n.t 'profile'

    within(".edit_address") do
      fill_in 'address_zipcode', :with => '12543'

      click_button I18n.t 'save'
    end

    expect(page).to have_field('address_zipcode', with: '12543')
  end
end