require 'features/features_spec_helper'

feature "Delete categories", :js => true do
  background do
    FactoryGirl.create :category, title: "for kids only"
    user = FactoryGirl.create :admin_customer
    login_as(user, :scope => :customer)
  end
  
  scenario "administrator deletes category in panel" do
    visit rails_admin_path
    within(".category_links") do
      click_link 'List'
    end
    click_link 'Delete'
    
    within(".edit_category") do
      click_button "Yes, I'm sure"
    end

    expect(page).to have_content 'List of Categories' 
    expect(page).to_not have_content 'for kids only' 
  end

end