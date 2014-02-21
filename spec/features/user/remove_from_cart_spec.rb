require 'features/user_features_spec_helper'

feature "cart management" do
  given!(:book) { FactoryGirl.create :book }

  scenario "User removes book from his cart" do
    visit books_path
    click_link book.title
    click_button I18n.t 'add_to_cart'
    click_link 'Cart'
    click_link 'Cancel'
    expect(page).to_not have_content book.title
  end
end