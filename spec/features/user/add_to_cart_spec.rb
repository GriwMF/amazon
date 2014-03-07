require 'features/features_spec_helper'

feature "cart management" do
  given!(:book) { FactoryGirl.create :book }

  background do
    login_as(FactoryGirl.create(:customer), :scope => :customer)
  end

  scenario "User puts book into a shopping cart through books page" do
    visit books_path
    click_link book.title
    click_button I18n.t 'add_to_cart'
    expect(page).to have_content 'Book was successefully added'
    click_link 'cart'
    expect(page).to have_content book.title
  end
end