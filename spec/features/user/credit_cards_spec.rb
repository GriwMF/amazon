require 'features/features_spec_helper'

feature "Credit cadrs management" do

  let(:user) { FactoryGirl.create :customer }

  background do
    login_as(user, :scope => :customer)
  end

  scenario "User adds new credit card to account" do
    visit books_path
    click_link I18n.t 'profile'
    click_link I18n.t 'credit_cards'
    click_link I18n.t 'new_card'

    within("#new_credit_card") do
      fill_in 'credit_card_firstname', :with => 'Andrew'
      fill_in 'credit_card_lastname', :with => 'Griw'
      fill_in 'credit_card_number', :with => '1234' * 4
      fill_in 'credit_card_cvv', :with => '154'
      fill_in 'credit_card_expiration_month', :with => '11'
      fill_in 'credit_card_expiration_year', :with => Time.now.year + 1

      click_button I18n.t 'save'
    end

    expect(page).to have_content 'Andrew'
    expect(page).to have_content '1234' * 4
  end

  scenario "User edits lastname of existing credit card" do 
    FactoryGirl.create :credit_card, customer_id: user.id
    visit books_path
    click_link I18n.t 'profile'
    click_link I18n.t 'credit_cards'
    click_link I18n.t 'edit'   

    within(".edit_credit_card") do
      fill_in 'credit_card_lastname', :with => 'Ilidrhtdf'

      click_button I18n.t 'save'
    end

    expect(page).to have_content 'Ilidrhtdf'
  end
end