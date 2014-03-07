require 'features/features_spec_helper'

feature "Show books", :js => true do
  background do
    FactoryGirl.create :book, title: "War and Peace"
    user = FactoryGirl.create :admin_customer
    login_as(user, :scope => :customer)
  end
  
  scenario "adminitrator viewing book in panel" do
    visit rails_admin_path
    within(".book_links") do
      click_link 'List'
    end
    click_link 'Show'

    expect(page).to have_content 'Basic info' 
    expect(page).to have_content 'War and Peace' 
  end

end