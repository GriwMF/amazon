require 'features/user_features_spec_helper'

feature "review", js: true do
  given!(:book) { FactoryGirl.create :book }

  scenario "User adds review to a book" do
      visit books_path
      click_link book.title
      click_link I18n.t 'rate', scope: [:books, :show]
      within("#book_rating") do
        fill_in 'rating', :with => '4'
        fill_in 'text', :with => 'Book is ok'
        click_button 'Rate'
      end
      expect(page).to have_content 'Success! Please, wait for rating confirmation'
  end
end