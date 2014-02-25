require 'features/features_spec_helper'

feature "account registration" do
  scenario "User establishes a new account" do
    visit root_path
    click_link 'Register'
    within('#new_customer') do
      fill_in 'customer_email', :with => 'andrew@microsoft.com'
      fill_in 'customer_firstname', :with => 'Andrew'
      fill_in 'customer_lastname', :with => 'Rabgrhz'
      fill_in 'customer_password', :with => '123' * 3
      fill_in 'customer_password_confirmation', :with => '123' * 3

      click_button 'Sign up'
    end

    expect(page).to have_content('Welcome! You have signed up successfully.')
  end
end