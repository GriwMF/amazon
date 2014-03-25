require 'features/features_spec_helper'

feature "Access to admin panel" do
  let(:admin) { FactoryGirl.create :admin_customer }
  let(:user) { FactoryGirl.create :customer }
  
  scenario "An administrator navigates to panel through index page" do
    login_as(admin, :scope => :customer)
    visit root_path
    click_link 'Admin Panel'
    expect(page).to have_content 'Site Administration'
  end
  
  scenario "An administrator accesses panel by entering address in browser" do
    login_as(admin, :scope => :customer)
    visit rails_admin_path
    expect(page).to have_content 'Site Administration'
  end
  
  scenario "A user has no link to admin panel" do
    login_as(user, :scope => :customer)
    visit root_path
    expect(page).to_not have_content 'Admin Panel'    
  end
  
  scenario "A user has no accesses to panel by direct link" do
    login_as(user, :scope => :customer)
    visit rails_admin_path
    expect(page).to_not have_content 'Site Administration' 
  end
end