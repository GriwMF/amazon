require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature "Changing order's states", :js => true do
  after { Warden.test_reset! }
  
  background do
    user = FactoryGirl.create :admin_customer
    login_as(user, :scope => :customer)
  end
  
  scenario "adminitrator changes state from in_progress to in_queue in panel" do
    FactoryGirl.create :order
    visit rails_admin_path
    within(".order_links") do
      click_link 'List'
    end
    click_link 'Show'
    click_link 'check out!'
    expect(page).to have_content 'in queue' 
  end
  
  scenario "adminitrator changes state from in_queue to in_delivery in panel" do
    FactoryGirl.create :order, state: "in_queue"
    visit rails_admin_path
    within(".order_links") do
      click_link 'List'
    end
    click_link 'Show'
    click_link 'ship'
    expect(page).to have_content 'in delivery' 
  end

  scenario "adminitrator changes state from in_delivery to delivered in panel" do
    FactoryGirl.create :order, state: "in_delivery"
    visit rails_admin_path
    within(".order_links") do
      click_link 'List'
    end
    click_link 'Show'
    click_link 'shipped'
    expect(page).to have_content 'delivered' 
  end
end