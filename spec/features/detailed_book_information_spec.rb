require 'spec_helper'

feature "detailed information" do

  scenario "A user viewing detailed information of a book" do
    book = FactoryGirl.create :book
    visit books_path
    click_link book.title
    expect(page).to have_content book.title
    expect(page).to have_content book.descirption
    expect(page).to have_content book.in_stock
    expect(page).to have_content book.price
    expect(page).to have_content "Wished by:"
    expect(page).to have_content book.wished
  end
end