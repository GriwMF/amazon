require 'spec_helper'
include Warden::Test::Helpers

feature "Edit books", :js => true do
  background do
    FactoryGirl.create :book
    user = FactoryGirl.create :admin_customer
    login_as(user, :scope => :customer)
  end
  
  scenario "administrator edit book in panel" do
    visit rails_admin_path
    within(".book_links") do
      click_link 'List'
    end
    click_link 'Edit'

    within("#edit_book") do
      fill_in 'Title', :with => 'War and Peace'
      fill_in 'Description', :with => 'something about war and peace'
      fill_in 'Price', :with => '24.99'
      fill_in 'In stock', :with => '5'

      click_button 'Save'
    end

    expect(page).to have_content 'War and Peace' 
  end

end