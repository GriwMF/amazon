require 'spec_helper'
include Warden::Test::Helpers

feature "Delete books", :js => true do
  background do
    FactoryGirl.create :book, title: "War and Peace"
    user = FactoryGirl.create :admin_customer
    login_as(user, :scope => :customer)
  end
  
  scenario "administrator delete book in panel" do
    visit rails_admin_path
    within(".book_links") do
      click_link 'List'
    end
    click_link 'Delete'
    
    within(".edit_book") do
      click_button "Yes, I'm sure"
    end

    expect(page).to have_content 'List of Books' 
    expect(page).to_not have_content 'War and Peace' 
  end

end