require 'features/user_features_spec_helper'

feature "cart management" do
  given!(:book) { FactoryGirl.create :book }

  scenario "User puts book into a shopping cart through books page" do
    visit books_path
    click_link book.title
    click_button I18n.t 'add_to_cart'
    expect(page).to have_content 'Book was successefully added'
    click_link I18n.t 'cart'
    expect(page).to have_content book.title
  end
end