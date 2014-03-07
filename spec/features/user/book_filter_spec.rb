require 'features/features_spec_helper'

feature "Book's filter" do
  given(:category) { FactoryGirl.create :category, title: "ok bok"}
  given(:author) { FactoryGirl.create :author, firstname: "Allen", lastname: "Jigirtbghm"}
  given(:good_book) { FactoryGirl.create :book, title: "Good book"}
  given(:bad_book) { FactoryGirl.create :book, title: "This book is forbidden"}

  background do
    login_as(FactoryGirl.create(:customer), :scope => :customer)
    good_book.authors << author
    good_book.categories << category
    visit books_path
  end

  scenario 'User navigates site by category' do
    click_link category.title
    expect(page).to have_content good_book.title
    expect(page).not_to have_content bad_book.title 
  end
end
