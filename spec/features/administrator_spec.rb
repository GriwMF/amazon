require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature "Administrator's work" do
  after { Warden.test_reset! }
  background do
    user = FactoryGirl.create :customer
    user.confirmed_at = Time.now
    user.admin = true
    user.save
    login_as(user, :scope => :customer)
  end
  
  feature "Books management" do
    scenario "An administrator can add book" do
      visit new_book_path
      within("#new_book") do
        fill_in 'book_title', :with => 'War and Peace'
        fill_in 'book_descirption', :with => 'something about war and peace'
        fill_in 'book_price', :with => '24.99'
        fill_in 'book_in_stock', :with => '45'
        click_button 'Save'
      end
      expect(page).to have_content 'Book was successfully created.'
      expect(page).to have_content 'War and Peace'
    end
    
    scenario "An administrator can remove book" do
      FactoryGirl.create :book
      visit books_path
      click_link 'Destroy'
      expect(page).to_not have_content 'Destroy'
      expect(page).to have_content 'Listing books'
    end
    
    scenario "An administrator can edit book" do
      book = FactoryGirl.create :book
      visit edit_book_path(book)
      within(".edit_book") do
        fill_in 'book_title', :with => 'Johny be Goodie'
        fill_in 'book_descirption', :with => 'something about war and peace'
        click_button 'Save'
      end
      expect(page).to have_content 'Johny be Goodie'
      expect(page).to have_content 'something about war and peace'
    end
  end
  
  feature "Category management" do
    scenario "An administrator can add category" do
      visit new_category_path
      within("#new_category") do
        fill_in 'category_title', :with => 'Bestsellers'
        click_button 'Save'
      end
      expect(page).to have_content 'Category was successfully created.'
      expect(page).to have_content 'Bestsellers'
    end
    
    scenario "An administrator can remove category" do
      FactoryGirl.create :category
      visit categories_path
      click_link 'Destroy'
      expect(page).to_not have_content 'Destroy'
      expect(page).to have_content 'Listing categories'
    end
    
    scenario "An administrator can edit category" do
      category = FactoryGirl.create :category
      visit edit_category_path(category)
      within(".edit_category") do
        fill_in 'category_title', :with => 'Johny be Goodie'
        click_button 'Save'
      end
      expect(page).to have_content 'Johny be Goodie'
    end    
  end
  
  feature "Authors management" do
    scenario "An administrator can add authors" do
      visit new_author_path
      within("#new_author") do
        fill_in 'author_firstname', :with => 'Jordano'
        fill_in 'author_lastname', :with => 'Bruno'
        click_button 'Save'
      end
      expect(page).to have_content 'Author was successfully created.'
      expect(page).to have_content 'Jordano'
      expect(page).to have_content 'Bruno'
    end
    
    scenario "An administrator can remove authors" do
      FactoryGirl.create :author
      visit authors_path
      click_link 'Destroy'
      expect(page).to_not have_content 'Destroy'
      expect(page).to have_content 'Listing authors'
    end
    
    scenario "An administrator can edit authors" do
      author = FactoryGirl.create :author
      visit edit_author_path(author)
      within(".edit_author") do
        fill_in 'author_firstname', :with => 'Ivan'
        fill_in 'author_lastname', :with => 'Bruno'
        click_button 'Save'
      end
      expect(page).to have_content 'Ivan'
      expect(page).to have_content 'Bruno'
    end    
  end
  
  feature "Connecting books to categories and authors" do
    given(:book) { FactoryGirl.create :book }

    scenario "An administrator can connect book to categories" do
      category = FactoryGirl.create :category
      visit edit_book_path(book)
      within("#assign_categories") do
        select category.title, :from => 'categories[id]'
        click_button 'Assign'
      end
      expect(page).to have_content "Category: #{category.title} unassign"
    end
    
    scenario "An administrator can connect book to authors" do
      author = FactoryGirl.create :author
      visit edit_book_path(book)
      within("#assign_authors") do
        select author.full_name, :from => 'authors[id]'
        click_button 'Assign'
      end
      expect(page).to have_content "Author: #{author.full_name} unassign"
    end
  end
  
  feature "Approving or rejecting reviews" do
    given!(:rating) { FactoryGirl.create :rating }
    
    background do
      visit root_path
      click_link 'Check ratings'
    end
    
    scenario "An administrator accept review" do
      click_link 'Approve'
      click_link 'Amazon'
      click_link rating.book.title
      expect(page).to have_content rating.text
    end
    
    scenario "An administrator decline review" do
      click_link 'Decline'
      expect(page).not_to have_content rating.text
    end
  end
end