require 'features/features_spec_helper'

feature "Edit categories", :js => true do
  background do
    FactoryGirl.create :category
    user = FactoryGirl.create :admin_customer
    login_as(user, :scope => :customer)
  end
  
  scenario "administrator editing categories in panel" do
    visit rails_admin_path
    within(".category_links") do
      click_link 'List'
    end
    click_link 'Edit'

    within("#edit_category") do
      fill_in 'Title', :with => 'for kids only'

      click_button 'Save'
    end

    expect(page).to have_content 'for kids only'
  end

end