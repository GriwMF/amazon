require 'features/features_spec_helper'

feature "Creating authors", :js => true do
  background do
    user = FactoryGirl.create :admin_customer
    login_as(user, :scope => :customer)
  end
  
  scenario "admin creates new author in panel" do
    visit rails_admin_path
    within(".author_links") do
      click_link 'Add new'
    end
    expect(page).to have_content 'New Author'
    expect(page).to have_content 'Description' 
    within("#new_author") do
      fill_in 'Firstname', :with => 'Ivan'
      fill_in 'Lastname', :with => 'Susanin'
      fill_in 'Description', :with => 'not very good author'

      click_button 'Save'
    end
    
    within(".author_links") do
      click_link 'List'
    end
    expect(page).to have_content 'Ivan'
    expect(page).to have_content 'Susanin'
    expect(page).to have_content 'not very good author'
  end

end