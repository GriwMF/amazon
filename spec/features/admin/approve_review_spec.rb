require 'features/features_spec_helper'

feature "Approve review", :js => true do
  
  background do
    user = FactoryGirl.create :admin_customer
    login_as(user, :scope => :customer)
  end
  
  scenario "adminitrator approves review in admin panel" do
    FactoryGirl.create :rating, text: "this is rating"
    visit rails_admin_path
    within(".rating_links") do
      click_link 'Ratings'
    end

    expect(page).to have_content 'this is rating' 
    click_link 'approve'
    # click_link 'Ratings'
    expect(page).to have_content 'approved' 
    expect(page).to have_content 'this is rating' 
  end
  
end