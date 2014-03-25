require 'features/features_spec_helper'

feature "Delete authors", :js => true do
  background do
    FactoryGirl.create :author, firstname: "Aburahrgrt"
    user = FactoryGirl.create :admin_customer
    login_as(user, :scope => :customer)
  end
  
  scenario "administrator deletes author in panel" do
    visit rails_admin_path
    within(".author_links") do
      click_link 'List'
    end
    click_link 'Delete'
    
    within(".edit_author") do
      click_button "Yes, I'm sure"
    end

    expect(page).to have_content 'List of Authors' 
    expect(page).to_not have_content 'Aburahrgrt' 
  end

end