require 'spec_helper'
include Warden::Test::Helpers

feature "Edit authors", :js => true do
  background do
    FactoryGirl.create :author
    user = FactoryGirl.create :admin_customer
    login_as(user, :scope => :customer)
  end
  
  scenario "administrator edit author in panel" do
    visit rails_admin_path
    within(".author_links") do
      click_link 'List'
    end
    click_link 'Edit'

    within("#edit_author") do
      fill_in 'Firstname', :with => 'Ivan'
      fill_in 'Lastname', :with => 'Susanin'
      fill_in 'Description', :with => 'not very good author'

      click_button 'Save'
    end

    expect(page).to have_content 'Ivan'
    expect(page).to have_content 'Susanin'
    expect(page).to have_content 'not very good author'
  end

end