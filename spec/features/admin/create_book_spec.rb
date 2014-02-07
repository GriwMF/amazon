require 'spec_helper'
include Warden::Test::Helpers

feature "Creating books", :js => true do
  background do
    user = FactoryGirl.create :admin_customer
    login_as(user, :scope => :customer)
  end
  
  scenario "admin creates book in panel" do
    visit rails_admin_path
    within(".book_links") do
      click_link 'Add new'
    end
    expect(page).to have_content 'New Book'
    expect(page).to have_content 'Price' 
    within("#new_book") do
      fill_in 'Title', :with => 'War and Peace'
      fill_in 'Description', :with => 'something about war and peace'
      fill_in 'Price', :with => '24.99'
      fill_in 'In stock', :with => '5'

      click_button 'Save'
    end
    
    within(".book_links") do
      click_link 'List'
    end
    expect(page).to have_content 'War and Peace' 
  end

end