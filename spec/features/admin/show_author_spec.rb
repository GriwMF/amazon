require 'features/features_spec_helper'

feature "Show Authors", :js => true do
  background do
    FactoryGirl.create :author, firstname: "Aburahrgrt"
    user = FactoryGirl.create :admin_customer
    login_as(user, :scope => :customer)
  end
  
  scenario "adminitrator viewing author information in panel" do
    visit rails_admin_path
    within(".author_links") do
      click_link 'List'
    end
    click_link 'Show'

    expect(page).to have_content 'Basic info' 
    expect(page).to have_content 'Aburahrgrt' 
  end

end