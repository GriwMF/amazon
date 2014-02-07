require 'spec_helper'


feature "Navigating" do
pending do
  given(:category) { FactoryGirl.create :category, title: "ok bok"}
  given(:author) { FactoryGirl.create :author, firstname: "Allen", lastname: "Jigirtbghm"}
  given(:good_book) { FactoryGirl.create :book, title: "Good book"}
  given(:bad_book) { FactoryGirl.create :book, title: "This book is forbidden"}

  background do
    good_book.authors << author
    good_book.categories << category
    visit navigation_show_path
  end

  after do
    expect(page).to have_content good_book.title
    expect(page).not_to have_content bad_book.title  
  end

  scenario "User can navigate site by caterogy" do
    click_link category.title
  end
  
  scenario "User can navigate site by author" do
    within("#sort_by_author") do
      select author.full_name, :from => 'authors_filter[id]'
      click_button 'Search'
    end
  end

  scenario "User can navigate site by book's title" do
    within("#sort_by_book") do
      fill_in 'title', :with => good_book.title
      click_button 'Search'
    end
  end 
end
end