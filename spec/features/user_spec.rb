require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature "User's actions" do
  after { Warden.test_reset! }
  let(:user) { FactoryGirl.create :customer }
  
  background do

    user.confirmed_at = Time.now
    user.save
    login_as(user, :scope => :customer)
  end
  
  feature "An user can buy books" do
    given!(:book) { FactoryGirl.create :book }
    
    background do
      visit books_path
      click_link 'Add to cart'
    end
    
    scenario "An user can put books into a shopping cart" do
      expect(page).to have_content 'Book was successefully added'
      click_link 'Cart'
      expect(page).to have_content book.title
    end
    
    scenario "An user can remove books from his cart" do
      click_link 'Cart'
      click_link 'Cancel'
      expect(page).to_not have_content book.title
    end
    
    scenario "An user can complete offer with filling his addreses and credit card" do
      click_link 'Cart'
      click_link 'Addresses'
      click_link 'New Address'
      
      within("#new_address") do
        fill_in 'address_country', :with => 'Ukraine'
        fill_in 'address_address', :with => '54 blablalba st, apt 666'
        fill_in 'address_zipcode', :with => '012574'
        fill_in 'address_city', :with => 'Kiev'
        fill_in 'address_phone', :with => '+38-097-542-36-54'
        click_button 'Save'
      end
      expect(page).to have_content "Address was successfully created."
      
      click_link 'Cart'
      click_link 'Credit cards'
      click_link 'New Credit card'
      
      within("#new_credit_card") do
        fill_in 'credit_card_firstname', :with => 'Andrew'
        fill_in 'credit_card_lastname', :with => 'Griw'
        fill_in 'credit_card_number', :with => '1234' * 4
        fill_in 'credit_card_cvv', :with => '154'
        fill_in 'credit_card_expiration_month', :with => '11'
        fill_in 'credit_card_expiration_year', :with => Time.now.year + 1
        click_button 'Save'
      end
      expect(page).to have_content "Credit card was successfully created."
      
      click_link 'Cart'

      within("#check_out") do
        address = "Ukraine Kiev 54 blablalba st, apt 666"
        select address, :from => 'ship_addr[id]'
        select address, :from => 'bill_addr[id]'
        select '1234' * 4, :from => 'credit_card[id]'
        click_button 'Check out'
      end
      
      expect(page).to have_content 'Success! Your order is under processing.'
    end
  end
  
  feature "A user can rate and review books" do
    scenario "add rewiew" do
      book = FactoryGirl.create :book
      visit books_path
      click_link book.title
      within("#book_rating") do
        fill_in 'rating', :with => '4'
        fill_in 'text', :with => 'Book is ok'
        click_button 'Rate'
      end
      expect(page).to have_content 'Success! Please, wait for rating confirmation'
    end
  end
  
  feature "Editing account" do
    background do
      #customer = Customer.last
      
      FactoryGirl.create :address, customer_id: user.id
      FactoryGirl.create :credit_card, customer_id: user.id
      
      visit root_path
    end
    
    scenario "change credit card (number)" do
      click_link 'Profile'
      click_link 'Credit cards'
      click_link 'Edit'
      within(".edit_credit_card") do
        fill_in 'credit_card_number', :with => '1234' * 4
        click_button 'Save'
      end
      
      expect(page).to have_content 'Credit card was successfully updated.'
      expect(page).to have_content '1234' * 4
    end
    
    scenario "change address (zipcode)" do
      click_link 'Profile'
      click_link 'Addresses'
      click_link 'Edit'
      within(".edit_address") do
        fill_in 'address_zipcode', :with => '1234000'
        click_button 'Save'
      end
      
      expect(page).to have_content 'Address was successfully updated.'
      expect(page).to have_content '1234000'
    end
    
   scenario "change name" do
      click_link 'Profile'
      click_link 'Edit'
      within(".edit_customer") do
        fill_in 'customer_firstname', :with => 'Apu'
        fill_in 'customer_lastname', :with => 'Igrightpf'
        click_button 'Save'
      end
      
      expect(page).to have_content 'Profile was successfully updated.'
      expect(page).to have_content 'Apu'
      expect(page).to have_content 'Igrightpf'
    end    
  end

  feature "wish list" do
    given!(:book) { FactoryGirl.create :book }
    
    background do
      book.authors << (FactoryGirl.create :author)
      visit root_path
      click_link book.title
      click_link 'Add to wish list'
    end
    
    scenario "add book to wish list" do
      expect(page).to have_content 'Successefully added'
      click_link 'Profile'
      expect(page).to have_content book.title
    end
    
    scenario "wished books are visible to others" do
      logout(:user)
      click_link 'Amazon'
      click_link book.title
      expect(page).to have_content 'Wished by: 1'
    end
  end
  
  feature "recend orders" do
    given!(:order) { FactoryGirl.create :order_with_book_price_5_and_quantity_3, customer_id: user.id, completed_at: Time.now }

    scenario "user can see recent orders" do
      visit root_path
      click_link 'Recent orders'
      expect(page).to have_content order.order_items[0].book.title
    end
  end
end