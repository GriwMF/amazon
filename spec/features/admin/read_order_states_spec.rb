require 'spec_helper'
include Warden::Test::Helpers

feature "Read order's states", :js => true do
  background do
    FactoryGirl.create :order
    user = FactoryGirl.create :admin_customer
    login_as(user, :scope => :customer)
  end
  
  scenario "adminitrator views order's states in panel" do
    visit rails_admin_path
    within(".order_links") do
      click_link 'List'
    end
    
    expect(page).to have_content 'in_progress' 
  end

end