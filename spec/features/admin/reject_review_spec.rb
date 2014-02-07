require 'spec_helper'
include Warden::Test::Helpers

feature "Reject review", :js => true do
  
  background do
    user = FactoryGirl.create :admin_customer
    login_as(user, :scope => :customer)
  end
  
  scenario "adminitrator rejects review in admin panel" do
    FactoryGirl.create :rating, text: "this is rating"
    visit rails_admin_path
    within(".unapproved_rating_links") do
      click_link 'Unapproved ratings'
    end
    expect(page).to have_content 'this is rating' 
    click_link 'decline'
    expect(page).to_not have_content 'this is rating' 
    click_link 'Ratings'
    expect(page).to_not have_content 'this is rating' 
  end
  
end