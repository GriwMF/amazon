require 'features/features_spec_helper'

feature "Edit profile" do
  background do
    login_as(FactoryGirl.create(:customer), :scope => :customer)
  end
  
  scenario "User edits his first and last name" do
      visit books_path
      click_link I18n.t 'profile'
      click_link I18n.t 'edit'

      within("#edit_customer") do
        fill_in 'customer_firstname', :with => 'Ivan'
        fill_in 'customer_lastname', :with => 'Harenghtds'

        fill_in 'customer_current_password', :with => "123123123"
        click_button 'Update'
      end
      expect(page).to have_content 'You updated your account successfully.'
      click_link I18n.t 'profile'
      expect(page).to have_content 'Ivan'
      expect(page).to have_content 'Harenghtds'
  end
end