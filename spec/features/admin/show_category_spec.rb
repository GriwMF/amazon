require 'spec_helper'
include Warden::Test::Helpers

feature "Show categories", :js => true do
  background do
    FactoryGirl.create :category, title: "for kids only"
    user = FactoryGirl.create :admin_customer
    login_as(user, :scope => :customer)
  end
  
  scenario "adminitrator viewing category information in panel" do
    visit rails_admin_path
    within(".category_links") do
      click_link 'List'
    end
    click_link 'Show'

    expect(page).to have_content 'Basic info' 
    expect(page).to have_content 'for kids only' 
  end

end