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

  scenario "User is filtering books by caterogy" do
    select category.title, :from => '[categories_id][]'
    click_button I18n.t('apply')
    expect(page).to have_content good_book.title
    expect(page).not_to have_content bad_book.title 
  end
  
  scenario "User is filtering books by author" do
    select author.full_name, :from => '[authors_id][]'
    click_button I18n.t('apply')
    expect(page).to have_content good_book.title
    expect(page).not_to have_content bad_book.title 
  end

  scenario "User is filtering books by title" do
    select good_book.title, :from => '[books_id][]'
    click_button I18n.t('apply')
    expect(page).to have_content good_book.title
    expect(page).not_to have_content bad_book.title 
  end 
end
