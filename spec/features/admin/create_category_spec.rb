require 'features/features_spec_helper'

feature "Creating categories", :js => true do
  background do
    user = FactoryGirl.create :admin_customer
    login_as(user, :scope => :customer)
  end
  
  scenario "admin creates a new category in panel" do
    visit rails_admin_path
    within(".category_links") do
      click_link 'Add new'
    end
    expect(page).to have_content 'New Category'
    within("#new_category") do
      fill_in 'Title', :with => 'for kids only'

      click_button 'Save'
    end
    
    within(".category_links") do
      click_link 'List'
    end
    expect(page).to have_content 'for kids only'
  end

end